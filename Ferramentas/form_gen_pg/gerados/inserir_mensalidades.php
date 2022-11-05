<?php

$host='127.0.0.1';
$user='postgres';
$password='postgres';
$dbname='cad_revenda';

$conexao = pg_connect("host=127.0.0.1 user=postgres password=postgres dbname=");
if(!conexao) die($pg_last_error."Error: Falha ao conectar ao banco ");
$codigo = $_POST['codigo'];
$login = $_POST['login'];
$vencimento = $_POST['vencimento'];

$strInsert = "INSERT INTO mensalidades (codigo,login,vencimento) VALUES ('$codigo','$login','$vencimento')";


$insert = pg_query($conexao, $strInsert);

if ($insert){
	echo "<center>Registro Inserido com sucesso!<br>";
}else{
	echo "<center>Erro: Falha ao inserir o registro!<br>";
}
?>