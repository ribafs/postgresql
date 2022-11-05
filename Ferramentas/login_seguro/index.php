<?php
	session_start();
	$token = md5(uniqid(rand(), true));
	$_SESSION['token'] = $token;
?>

<head><title>Login de Acesso ao Sistema</title></head>

<body bgColor="black" text="yellow" onLoad="document.frmLogin.login.focus()">
<br><br>
<h2 align=center>Login de Acesso ao Sistema</h2>
<br><br><br><br>
<table border=0 align=center>

<form method="POST" action="login.php" name="frmLogin">
<input type="hidden" name="token" value="<?php echo $token; ?>" /><br>
<tr><td>Login:</td><td><input type="text" name="login" ></td></tr>
<tr><td>Senha</td><td><input type="text" name="senha"></td></tr>
<tr><td>Número</td><td><img src="captcha-image.php" title="Digite este número à direita" />
	<input type="text" name="captcha" size="7" maxlength="6" value="" title="Digite aqui o número da esquerda" /></td></tr>
<tr><td colspan=2 align=center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="submit" value="Acessar"></td></tr>
</form></table></body>

<?php
	if($_SESSION['log']){
		print "<center><br><br><br>".$_SESSION['log']; // Mensagem de erro que virá de login.php
	}
?>
