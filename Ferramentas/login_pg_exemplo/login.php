<?php
session_start();
if (isset($_POST['login']))
{
	include_once("config.inc.php");

	if (isset($_SESSION['token']) && $_POST['token'] == $_SESSION['token'])
	{
    	$login=$_POST['login'];
    	$senha=$_POST['senha'];    	
    	$senha=md5($senha);
	
   		$sql=" SELECT login,senha FROM usuarios WHERE login='$login' AND senha = '$senha'";
   		$qry= pg_query($con, $sql);

   		if(!$qry) print pg_last_error($con)."<br>Erro erro na consulta!";

   		if(pg_numrows($qry) > 0){
  			header("location: menu.php");
		}else{
			$_SESSION['voltar']="sim"; // Gravo essa variável no Session para disparar a mensagem de erro em vermelho na index.php
			header("location: index.php");  // Mais seguro voltar via PHP que via JS (location ou history.back())			
		}
    }
}else{
	header("location: http://www.google.com");  // Redirecionar sem nenhuma mensagem, pois o acesso não foi autorizado.
}
?>