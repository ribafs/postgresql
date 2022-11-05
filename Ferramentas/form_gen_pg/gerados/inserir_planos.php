<?php

$host='127.0.0.1';
$user='postgres';
$password='postgres';
$dbname='cad_revenda';

$conexao = pg_connect("host=127.0.0.1 user=postgres password=postgres dbname=");
if(!conexao) die($pg_last_error."Error: Falha ao conectar ao banco ");
$codigo = $_POST['codigo'];
$descricao = $_POST['descricao'];
$valor = $_POST['valor'];

$strInsert = "INSERT INTO planos (codigo,descricao,valor) VALUES ('$codigo','$descricao','$valor')";


$insert = pg_query($conexao, $strInsert);

if ($insert){
	echo "<center>Registro Inserido com sucesso!<br>";
}else{
	echo "<center>Erro: Falha ao inserir o registro!<br>";
}
?>