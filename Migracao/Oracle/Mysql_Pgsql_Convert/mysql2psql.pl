#!/usr/bin/perl
#
# Convert a mysqldump dump to something postgres can slurp
#
# Created: 2000-11-29 by Zach
#

$/ = ");";

$oldfh = select(STDOUT);
$| = 1;
select($oldfh);

$outputfile = $ARGV[1] || "output.sql";

$table_substitutions_re = "";
%table_substitutions = ();

open(IN, "<$ARGV[0]") || die("couldn't open input: $!");

print "Writing $outputfile ...";
open(OUTPUT, ">$outputfile") || die("coudn't open: $!");


$output_count = 0;
while ($sql = <IN>) {
    if ($output_count++ % 50 == 0) {
	print ".";
    }

    # Convert '#' comments to '--'
    $sql =~ s/^#/--/mg;

    if ($sql =~ /create table (\S+)/i) {
	$table_name = $1;

	# Special case for xach: i used mysql tables named foo_seq with
	# auto_increment keys for faking sequences. Don't convert those
	# to new tables, convert them to sequences.
	if ($table_name =~ /seq$/) {
	    push (@sequences, [$table_name]);
	}
	

	# Clean up the numeric types
	$sql =~ s/\b(tiny|medium|big)?int\(\d+\)/integer/g;
	$sql =~ s/ZEROFILL//;
	$sql =~ s/double\(\d+(,\d+)?\)/float8/;

	# Clean up the date types
	$sql =~ s/\bdate\b/datetime/g;
	$sql =~ s/\btime\b/datetime/g;
	$sql =~ s/\btimestamp\(\d+\)/datetime not null default now()/g;

	$sql =~ s/\bblob\b/text/g;



	# Convert auto-increment primary keys to use sequences
	if ($sql =~ /\b(\S+) integer .*auto_increment/) {
	    $column_name = $1;
	    $sequence_name = "${table_name}_${column_name}_seq";
	    $sql =~ s/auto_increment/default nextval('$sequence_name')/;
	    push(@sequences, [$sequence_name, $table_name, $column_name]);
	}

	# Convert enums
	$sql =~ s/\S+ enum\([^\)]+\)/convert_enums($&)/eg;

	# Mysql dumps have: UNIQUE name (name)
	# postgres expects just UNIQUE (name)
	$sql =~ s/UNIQUE \S+ \(/UNIQUE \(/g;

	# FIXME: add a --keys-to-indexes option or something
	$sql =~ s/^\s*KEY .*$//mig;
	$sql =~ s/,\s*\);$/\n\);/;

	# Remove default values for timestamps
	$sql =~ s/DEFAULT '0000-00-00( 00:00:00)?'//g;

	# Convert char to varchar (postgres space-pads chars)
	$sql =~ s/\bchar\(/varchar\(/g;
	
    }

    print OUTPUT $sql;
}

#
# Handle all sequences
#

foreach $seqref (@sequences) {
    ($seq_name, $tbl_name, $col_name) = @$seqref;
    print OUTPUT "create sequence $seq_name;\n";
    if ($tbl_name && $col_name) {
	print OUTPUT "select setval('$seq_name', (select max($col_name) from $tbl_name));\n";
    }
    print OUTPUT "\n";
}

print "done\n";


sub convert_enums {
    my($sql) = @_;
    
    if ($sql =~ /(\S+) enum\(([^\)]+)\)/) {
	$column_name = $1;
	$enum_values_orig = $2;
	$enum_values = $enum_values_orig;
	$enum_values =~ s/^'(.*)'$/$1/;
	@enum_values = split("','", $enum_values);
	$longest_enum = 0;
	map {
	    $longest_enum = length($_) if length($_) > $longest_enum;
	} @enum_values;
	$sql =~ s/$column_name enum\([^\)]+\)/$column_name varchar($longest_enum) check ($column_name in ($enum_values_orig))/;
    }
    
    return $sql;
}
