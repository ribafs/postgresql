<?php
// Conectar ao MySQL
$host="localhost";
$user="postgres";
$pass="postgres";
$port="5432";
$db="cms_agil";

$con=pg_connect("host=$host user=$user password=$pass port=$port dbname=$db");
if(!$con){
	print pg_last_error($con)."<br>Erro na conexão com o banco $db!";
}

?>