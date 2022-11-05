<?php

$host='127.0.0.1';
$user='postgres';
$password='postgres';
$dbname='cad_revenda';

$conexao = pg_connect("host=127.0.0.1 user=postgres password=postgres dbname=");
if(!conexao) die($pg_last_error."Error: Falha ao conectar ao banco ");
$login = $_POST['login'];
$senha = $_POST['senha'];
$nome = $_POST['nome'];
$cpf = $_POST['cpf'];
$email = $_POST['email'];
$rua = $_POST['rua'];
$numero = $_POST['numero'];
$complemento = $_POST['complemento'];
$cidade = $_POST['cidade'];
$uf = $_POST['uf'];
$ddd = $_POST['ddd'];
$telefone = $_POST['telefone'];
$fk_plano = $_POST['fk_plano'];
$fk_mensalidade = $_POST['fk_mensalidade'];

$strInsert = "INSERT INTO clientes (login,senha,nome,cpf,email,rua,numero,complemento,cidade,uf,ddd,telefone,fk_plano,fk_mensalidade) VALUES ('$login','$senha','$nome','$cpf','$email','$rua','$numero','$complemento','$cidade','$uf','$ddd','$telefone','$fk_plano','$fk_mensalidade')";


$insert = pg_query($conexao, $strInsert);

if ($insert){
	echo "<center>Registro Inserido com sucesso!<br>";
}else{
	echo "<center>Erro: Falha ao inserir o registro!<br>";
}
?>