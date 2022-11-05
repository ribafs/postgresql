#!/usr/bin/perl
$count = 1;
$arquivosaida = "populate.sql";
@chars = ("A" .. "Z", "a" .. "z", 0 .. 9);
@numbers = (1 .. 9);
@single_chars = ("a" .. "e");
$totalrecords = 5000; # 5 milhoes

open(OUTPUT, "> $arquivosaida");
print OUTPUT "DROP TABLE index_teste;\n";
print OUTPUT "CREATE TABLE index_teste (";
print OUTPUT "codigo INT, nome VARCHAR(10), numero INT, letra CHAR(1)";
print OUTPUT ");\n";
print OUTPUT "COPY index_teste (codigo, nome, numero, letra) FROM stdin;\n";
while ($count <= $totalrecords){
    $randstring = join("", @chars [map{rand @chars} ( 1 .. 8 ) ]);
    $randnum = join("", @numbers [map{rand @numbers} ( 1 .. 8 ) ]);
    $randletter = join("", @single_chars [map{rand @single_chars} (1)]);
    print OUTPUT
    #print OUTPUT "INSERT INTO index_teste VALUES($count,'$randstring',$randnum,'$randletter');\n";
    $count."\t".$randstring."\t".$randnum."\t".$randletter."\n";
    $count++;
};
#print OUTPUT "\n";
#print OUTPUT "\nCREATE INDEX indexteste_codigo_index ON index_teste(codigo);\n";
#print OUTPUT "CREATE INDEX indexteste_numero_index ON index_teste(numero);\n";
#print OUTPUT "VACUUM ANALYZE index_teste;\n";
close OUTPUT;
