<?php
// Conectar ao MySQL
define(HOST,"localhost");
define(USER,"root");
define(PASSWORD,"");
define(PORT,"3306");
define(DB,"cms_agil");
define(TABLE,"usuarios");
define(CAMPO_LOGIN,"login");
define(CAMPO_SENHA,"senha");
define(REDIR_SIM,"menu.php");
define(REDIR_NAO,"index.php");

$con=mysql_connect(HOST.":".PORT,USER,PASSWORD);
if($con){
	if(mysql_select_db(DB)){
	}else{
		print mysql_errno($con)." : " . mysql_error($con). "<br>Erro erro na seleção do banco DB!";
		exit;
	}
}else{
	print mysql_errno($con)." : " . mysql_error($con). "<br>Erro na conexão com o MySQL!";
	exit;	
}

// Validar nome de usuario, com mínimo e máximo de caracteres e se permite ou não maiúsculas
function valida_usuario($usuario, $min = 5, $max = 15, $maiusculas = true)
{        
	if (strlen($usuario) < $min || $usuario > $max)
    {
    	return false;
    }              
	if ($maiusculas)
    {
		$regexp='/[^A-Za-z0-9\_\-]/';
	}else{
		$regexp='/[^a-z0-9\_\-]/';
	}
              
	if (preg_match($regexp, $usuario))
	{
		return false;
	}
              
	return true;
}

?>
