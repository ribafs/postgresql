#!/bin/sh

# This small script will create full backups of your database named like
# [database name]-[date].sql
# where date is day of current date. This will make one month worth of
# backups. It will automatically backup *ALL* databases on system.

# directory in which to dump backups
dir=/backup/sql-backup

function do_dump () {
	echo -n `date +"%Y-%m-%d %H:%M:%S"` $db_name
	# you might want to comment this if you have different vacuuming policy
	psql -q -c "vacuum full analyze" $1
	file=$dir/$1-`date +%d`.sql.gz
	/usr/bin/pg_dump -i $1 | gzip > $file
	gzip -l $file | tail -1 | sed 's/  */ /g' | cut -d" " -f-4
}

psql -c "select datname from pg_database where not datistemplate order by datname" -A -t template1 | while read db_name
do
	do_dump $db_name
done

