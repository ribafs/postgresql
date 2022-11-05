<?
	/* Database connection */
	
   $conexao = pg_connect("dbname=$database user=$user password=$password host=$host port=$port");   
   if(!conexao) echo "Error: connection to database Fail!";
?>