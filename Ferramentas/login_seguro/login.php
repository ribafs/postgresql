<?php
session_start();
if (isset($_POST['login']))
{
	include_once($_SERVER["DOCUMENT_ROOT"]."/cms_agil/admin/config.inc.php");

	if (isset($_SESSION['token']) && $_POST['token'] == $_SESSION['token'] && (isset($_POST['captcha'])))
	{
    	$login=$_POST['login'];
    	$senha=$_POST['senha'];    	

		$_SESSION['log']="<font color=red><b>";
		if(!valida_usuario($login, $min = 5, $max = 15, $maiusculas = true)) $_SESSION['log'] .= "Tamanho inválido do login \"$login\".";
		if(!valida_usuario($senha, $min = 5, $max = 15, $maiusculas = true)) $_SESSION['log'] .= " Tamanho inválido da Senha.";

		if ($_SESSION['captcha'] == $_POST['captcha']){
   			$cap = "ok";	   		
   		}else{
   			$_SESSION['log'] .= " Número Errado!";
   		}

    	$senha=md5($senha);
	
   		$sql=" SELECT ".CAMPO_LOGIN.",".CAMPO_SENHA." FROM ".TABLE." WHERE ".CAMPO_LOGIN." ='$login' AND ".CAMPO_SENHA." = '$senha' ";

   		$qry= mysql_query($sql, $con);
   		if(!$qry) {
   			print mysql_errno($con)." : " . mysql_error($con). "<br>Erro na consulta!";
   			exit;
   		}

   		if((mysql_numrows($qry) > 0) && ($cap == "ok")){
  			$_SESSION['captcha']="";
  			header("location: ".REDIR_SIM);
  			//session_destroy();
		}else{			
			$_SESSION['log'] .="<br>Corrija e tente novamente!</b></font>"; // Disparar a mensagem de erro em vermelho na index.php
			header("location: ".REDIR_NAO);  // Mais seguro voltar via PHP que via JS	
			//session_destroy();
		}
    }
}else{
	header("location: http://www.google.com");  // Acesso indevido redirecionado sem nenhuma mensagem
}

// Obs.: os erros vão sendo capturados com a variável de Session log, para serem exibidos somente na index.

?>
