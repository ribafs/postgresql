#!/bin/sh
#
# Postgresql backup script
#
# Author
#  |
#  +-- speedboy (speedboy_420 at hotmail dot com)
#
# Last modified
#  |
#  +-- 16-10-2001
#  
# Version
#  |
#  +-- 1.1.2
#
# Description
#  |
#  +-- A bourne shell script that automates the backup, vacuum and 
#      analyze of databases running on a postgresql server.
#
# Tested on   
#  |
#  +-- Postgresql
#  |    |  
#  |    +-- 7.1.3
#  |    +-- 7.1.2
#  |    +-- 7.1
#  |    +-- 7.0
#  |
#  +-- Operating systems
#  |    |
#  |    +-- Linux Redhat 6.2
#  |    +-- Linux Mandrake 7.2
#  |    +-- FreeBSD 4.3
#  |
#  +-- Shells:
#       |
#       +-- sh
#       +-- bash
#       +-- ksh
#       
# Requirements
#  |
#  +-- grep, awk, sed, echo, gzip, chmod, touch, mkdir, date, psql, 
#      test, expr, dirname, find, tail, du, pg_dump, vacuum_db
#
# Installation
#  |
#  +-- Set the path and shell you wish to use for this script on the 
#  |   first line of this file. Keep in mind this script has only been
#  |   tested on the shells above in the "Tested on" section.
#  |
#  +-- Set the configuration variables below in the configuration
#  |   section to appropriate values.
#  |
#  +-- Remove the line at the end of the configuration section so that
#  |   the script will run.
#  |
#  +-- Now save the script and perform the following command:
#  |   
#  |   chmod +x ./pg_backup.sh
#  |   
#  +-- Now run the configuration test:
#  |
#  |   ./pg_backup.sh configtest
#  |
#  |   This will test the configuration details.
#  |
#  +-- Once you have done that add similiar entries given as examples
#      below to the crontab (`crontab -e`) without the the _first_ # 
#      characters.
#  
#      # Run a backup, vacuum and analyze every morning at 03:00
#      00 03 * * * /server/postgres/pg_backup.sh bva > /dev/null 2>&1
#      # Run a backup at 09:00, 12:00, 15:00, 18:00 everyday
#      00 09 * * * /server/postgres/pg_backup.sh b > /dev/null 2>&1
#      00 12 * * * /server/postgres/pg_backup.sh b > /dev/null 2>&1
#      00 15 * * * /server/postgres/pg_backup.sh b > /dev/null 2>&1
#      00 18 * * * /server/postgres/pg_backup.sh b > /dev/null 2>&1
#
# Restoration
#  |
#  +-- Restoration can be performed by using psql or pg_restore.
#  |   Here are two examples:
#  |          
#  |   a) If the backup is plain text:
#  |
#  |   Firstly gunzip your backup file (if it was gzipped).
#  |
#  |   gunzip backup_file.gz
#  |   psql -U postgres database < backup_file
#  |
#  |   b) If the backup is not plain text:
#  |
#  |   Firstly gunzip your backup file (if it was gzipped).
#  |
#  |   gunzip backup_file
#  |   pg_restore -d database -F {c|t} backup_file
#  |
#  |   Note: {c|t} is the format the database was backed up as.
#  |
#  |   pg_restore -d database -F t backup_file_tar
#  |
#  +-- Refer to the following url for more pg_restore help:  
#
#      http://www.postgresql.org/idocs/index.php?app-pgrestore.html
#
# To Do List
#              1. db_connectivity() is BROKEN, if the script can not create a 
#                 connection to postmaster it should die and write to the logfile 
#                 that it could not connect.
#              2. make configtest check for every required binary
#
########################################################################
#                          Start configuration                         #
########################################################################
#
##################
# Authentication #
##################
#
# Postgresql username to perform backups under.
postgresql_username="postgres"

# Postgresql password for the Postgresql username (if required).
postgresql_password="postabir"

# Postgresql hostname to connect to.
postgresql_hostname="localhost"

##################
# Locations      #
##################
#
# Location to place backups.
location_backup_dir="/usr/local/pgsql/backup"

# Location to place the pg_backup.sh logfile.
location_logfile="pgdump.log"

# Location of the psql binaries.
location_binaries="/usr/local/pgsql/bin"

##################
# Permissions    #
##################
#
# Permissions for the backup location.
permissions_backup_dir="0700"

# Permissions for the backup files.
permissions_backup_file="0600"

# Permissions for the backup logfile.
permissions_backup_log="0600"

##################
# Other options  #
##################
#
# Databases to exclude from the backup process (separated by a space)
exclusions="template"

# Backup format
#  |
#  +-- p = plain text : psql database < backup_file
#  +-- t = tar        : pg_restore -F t -d database backup_file
#  +-- c = custom     : pg_restore -F c -d database backup_file
#
backup_format="c"

# Backup large objects
backup_large_objects="yes"

# Gzip the backups
backup_gzip="yes"

# Date format for the backup
#  |
#  +-- %d-%m-%Y       = DD-MM-YYYY
#  +-- %Y-%m-%d       = YYYY-MM-DD
#  +-- %A-%b-%Y       = Tuesday-Sep-2001
#  +-- %A-%Y-%d-%m-%Y = Tuesday-2001-18-09-2001
#  | 
#  +-- For more date formats type:
#  
#      date --help
#
backup_date_format="%Y-%m-%d"

# You must comment out the line below before using this script
#echo "You must set all values in the configuration section in this file then run ./pg_backup.sh configtest before using this script" && exit 1
########################################################################
#                          End configuration                           #
########################################################################
#
#################
# Variables     #
#################
#
version="1.1.2"
current_time=`date +%H:%M`
date_info=`date +$backup_date_format`
PGUSER="$postgresql_username"
PGPASSWORD="$postgresql_password"
PATH="$PATH:/bin:/usr/bin"

# Export the variables
export PGUSER PGPASSWORD PATH

#################
# Checking      #
#################
#
# Check the backup format
if [ "$backup_format" = "p" ]; then
	backup_type="Plain text SQL"
	backup_args="-F $backup_format"

elif [ "$backup_format" = "t" ]; then
	backup_type="Tar"
	if [ "$backup_large_objects" = "yes" ]; then
		backup_args="-b -F $backup_format"
	else
		backup_args="-F $backup_format"
	fi
elif [ "$backup_format" = "c" ]; then
	backup_type="Custom"
	if [ "$backup_large_objects" = "yes" ]; then
		backup_args="-b -F $backup_format"
	else
		backup_args="-F $backup_format"
	fi
else
	backup_format="c"
	backup_args="-F $backup_format"
	backup_type="Custom"
fi

#################
# Functions     #
#################
#
# Obtain a list of available databases with reference to the user
# defined exclusions
db_connectivity() {
	tmp=`echo -n '(';echo -n $exclusions | sed 's/\ /\|/g'; echo -n ')'`
	if [ "$exclusions" = "" ]; then
		databases=`$location_binaries/psql -h $postgresql_hostname -U $postgresql_username -q -c "\l" template1 | sed -n 4,/\eof/p | grep -v rows\) | awk {'print $1'} || echo "Database connection could not be established at $timeinfo" >> $location_logfile`
	else
		databases=`$location_binaries/psql -h $postgresql_hostname -U $postgresql_username -q -c "\l" template1 | sed -n 4,/\eof/p | grep -v rows\) | grep -Ev $tmp | awk {'print $1'} || echo "Database connection could not be established at $timeinfo" >> $location_logfile`
	fi
}

# Setup the permissions according to the Permissions section
set_permissions() {
	# Make the backup directories and secure them.
	mkdir -m $permissions_backup_dir -p "$location_backup_dir/`date +%B-%Y`/$date_info"

	# Touch the log file
	touch "$location_logfile"

	# Make the backup tree
	chmod -f $permissions_backup_log "$location_logfile"
	chmod -f $permissions_backup_dir "$location_backup_dir"
	chmod -f $permissions_backup_dir "$location_backup_dir/`date +%B-%Y`"
	chmod -f $permissions_backup_dir "$location_backup_dir/`date +%B-%Y`/$date_info"
}

# Run backup
run_b() {
	for i in $databases; do
		start_time=`date '+%s'`
		timeinfo=`date '+%T %x'`
		
		"$location_binaries/pg_dump" $backup_args -h $postgresql_hostname $i > "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup"
		if [ "$backup_gzip" = "yes" ]; then
			gzip "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup"
			chmod $permissions_backup_file "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup.gz"	
		else 
			chmod $permissions_backup_file "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup"
		fi
		finish_time=`date '+%s'`
		duration=`expr $finish_time - $start_time`
		echo "Backup complete (duration $duration seconds) at $timeinfo for schedule $current_time on database: $i, format: $backup_type" >> $location_logfile
	done
	exit 1
}

# Run backup and vacuum
run_bv() {
	for i in $databases; do
		start_time=`date '+%s'`
		timeinfo=`date '+%T %x'`
		
		"$location_binaries/vacuumdb" -h $postgresql_hostname -U $postgresql_username $i >/dev/null 2>&1
		"$location_binaries/pg_dump" $backup_args -h $postgresql_hostname $i > "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup"
		if [ "$backup_gzip" = "yes" ]; then
			gzip "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup"
			chmod $permissions_backup_file "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup.gz"	
		else
			chmod $permissions_backup_file "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup"
		fi
		finish_time=`date '+%s'`
		duration=`expr $finish_time - $start_time`
		echo "Backup and Vacuum complete (duration $duration seconds) at $timeinfo for schedule $current_time on database: $i, format: $backup_type" >> $location_logfile
	done
	exit 1
}

# Run backup, vacuum and analyze
run_bva() {
	for i in $databases; do
		start_time=`date '+%s'`
		timeinfo=`date '+%T %x'`
		
		"$location_binaries/vacuumdb" -z -h $postgresql_hostname -U $postgresql_username $i >/dev/null 2>&1
		"$location_binaries/pg_dump" $backup_args -h $postgresql_hostname $i > "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup"
		if [ "$backup_gzip" = "yes" ]; then
			gzip "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup" 
			chmod $permissions_backup_file "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup.gz"
		else
			chmod $permissions_backup_file "$location_backup_dir/`date +%B-%Y`/$date_info/$current_time-postgresql_database-$i-backup"
		fi
		finish_time=`date '+%s'`
		duration=`expr $finish_time - $start_time`
		echo "Backup, Vacuum and Analyze complete (duration $duration seconds) at $timeinfo for schedule $current_time on database: $i, format: $backup_type" >> $location_logfile
	done
	exit 1
}

# Run vacuum
run_v() {
	for i in $databases; do
		start_time=`date '+%s'`
		timeinfo=`date '+%T %x'`
		
		"$location_binaries/vacuumdb" -h $postgresql_hostname -U $postgresql_username $i >/dev/null 2>&1
		finish_time=`date '+%s'`
		duration=`expr $finish_time - $start_time`
		echo "Vacuum complete (duration $duration seconds) at $timeinfo for schedule $current_time on database: $i " >> $location_logfile
	done
	exit 1
}

# Run vacuum and analyze
run_va() {
	for i in $databases; do
		start_time=`date '+%s'`
		timeinfo=`date '+%T %x'`
		
		"$location_binaries/vacuumdb" -z -h $postgresql_hostname -U $postgresql_username $i >/dev/null 2>&1
		finish_time=`date '+%s'`
		duration=`expr $finish_time - $start_time`
		echo "Vacuum and Analyze complete (duration $duration seconds) at $timeinfo for schedule $current_time on database: $i " >> $location_logfile
	done
	exit 1
}

# Print information regarding available backups
print_info() {
	echo "Postgresql backup script version $version"
	echo ""
	echo "Available backups:"
	echo ""
	if [ ! -d $location_backup_dir ] ; then
		echo "There are currently no available backups"
		echo ""
		exit 0
	else
	for i in `find "$location_backup_dir" -type d -maxdepth 2`; do
		echo "$i `du -h \"$i\" | tail -n 1 | awk {'print $1'}`"
		#for j in `ls "$location_backup_dir/$i"`; do
		#	echo "    $j `du -h \"$location_backup_dir/$i/$j\" | tail -n 1 | awk {'print $1'}`"
		#done
	done
	echo ""
	fi
	exit 1
}

# Print configuration test
print_configtest() {
	echo "Postgresql backup script version $version"
	echo ""
	echo "Configuration test..."
	echo ""

	# Check database connectivity information
	echo -n "Database hostname                    : "
	echo "$postgresql_hostname"
	echo -n "Database username                    : "
	echo "$postgresql_username"
	echo -n "Database connectivity                : "
	$location_binaries/psql -h $postgresql_hostname -U $postgresql_username -q -c "select now()" template1 > /dev/null 2>&1 && echo "Yes" || echo "Connection could not be established..."

	# Backup information
	echo ""
	echo "Backup information:"
	echo ""
	echo -n "Backup format                        : "
	if [ "$backup_format" = "p" ]; then
		echo "Plain text SQL"
	elif [ "$backup_format" = "t" ]; then
		echo "Tar"
	else
		echo "Custom"
	fi

	echo -n "Backup large objects                 : "
	if [ "$backup_large_objects" = "yes" ]; then
		echo "Yes"
	else
		echo "No"
	fi
	echo -n "Gzip backups                         : "
	if [ "$backup_gzip" = "yes" ]; then
		echo "Yes"
	else
		echo "No"
	fi
	echo -n "Backup date format                   : $date_info"
	echo ""

	# File locations
	echo -n "Backup directory                     : "
	echo "$location_backup_dir"
	echo -n "Backup logfile                       : "
	echo "$location_logfile"
	echo -n "Postgresql binaries                  : "
	echo "$location_binaries"

	# Backup file permissions

	echo -n "Backup directory permissions         : "
	echo "$permissions_backup_dir"
	echo -n "Backup file permissions              : "
	echo "$permissions_backup_file"
	echo -n "Backup log permissions               : "
	echo "$permissions_backup_log"

	# Databases that will be backed up
	echo -n "Databases that will be backed up     : "
	echo ""
	for i in $databases; do
		echo "                                       $i"
	done

	# Databases that will not be backed up
	echo -n "Databases that will not be backed up :"
	echo ""
	if [ "$exclusions" = "" ]; then
		echo "                                       none"
	else
		for i in $exclusions; do
			echo "                                       $i"
		done
		echo ""
	fi

	# Check if the backups location is writable
	echo "Checking permissions:"
	echo ""
	echo -n "Write access                         : $location_backup_dir: "
	# Needed to create/write to the dump location"
	test -w "$location_backup_dir" && echo "Yes" || echo "No"

	# Check if the logfile location is writable
	echo -n "Write access                         : $location_logfile: "
	# Needed to create/write to this scripts logfile"
	if [ ! -x $location_logfile ] ; then
		test -w `dirname "$location_logfile"` && echo "Yes" || echo "No"
	else
		test -w "$location_logfile" && echo "Yes" || echo "No"
	fi

	# Check if the binaries are executable
	echo -n "Execute access                       : $location_binaries/psql: "
	test -x $location_binaries/psql && echo "Yes" || echo "No"
	
	echo -n "Execute access                       : $location_binaries/pg_dump: "
	test -x $location_binaries/pg_dump && echo "Yes" || echo "No"

	echo -n "Execute access                       : $location_binaries/vacuumdb: "
	test -x $location_binaries/vacuumdb && echo "Yes" || echo "No"

	echo ""
	exit 1
}

# Print help
print_help() {
	echo "Postgresql backup script version $version"
	echo ""
	echo "Usage: $0 [options]"
	echo ""
	echo "Options:"
	echo "  b,          Backup ALL databases"
	echo "  bv,         Backup and Vacuum ALL databases"
	echo "  bva,        Backup, Vacuum and Analyze ALL databases"
	echo "  v,          Vacuum ALL databases"
	echo "  va,         Vacuum and Analyze ALL databases"
	echo "  info,       Information regarding all available backups"
	echo "  configtest, Configuration test"
	echo "  help,       This message"
	echo ""
	echo "Report bugs to <speedboy_420 at hotmail dot com >."
	exit 1
}

case "$1" in
	# Run backup
	b)
		db_connectivity
		set_permissions
		run_b
		exit 1
		;;
	# Run backup and vacuum
	bv)
		db_connectivity
		set_permissions
		run_bv
		exit 1
		;;

	# Run backup, vacuum and analyze
	bva)
		db_connectivity
		set_permissions
		run_bva
		exit 1
		;;

	# Run vacuum
	v)
		db_connectivity
		set_permissions
		run_v
		exit 1
		;;

	# Run vacuum and analyze
	va)
		db_connectivity
		set_permissions
		run_va
		exit 1
		;;

	# Print info
	info)
		set_permissions
		print_info
		exit 1
		;;

	# Print configtest
	configtest)
		db_connectivity
		set_permissions
		print_configtest
		exit 1
		;;
	
	# Default
	*)
		print_help
		exit 1
		;;
esac
