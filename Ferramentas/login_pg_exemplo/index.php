<?php
	session_start();
	$token = md5(uniqid(rand(), true));
	$_SESSION['token'] = $token;
	if($_SESSION['voltar']=="sim"){
		print "<font color='red'><b>Login ou Senha inválidos. Corrija e tente novamente.</b></font>";			
	}
?>

<form method="POST" action="login.php">
	<input type="hidden" name="token" value="<?php echo $token; ?>" /><br>
	Login: <input type="text" name="login" ><br />
	Senha: <input type="text" name="senha"><br />
	<input type="submit" value="Acessar">
</form>