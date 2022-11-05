<html>
<head>
<title>Gerador de Formulário em PHP com PostgreSQL</title>
</head>
<body onLoad="document.frmForm.database.focus()">
<h2>Gerador de Formulário em PHP com PostgreSQL</h2>
<center>
<br><br><br>
<form method="post" name="frmForm" action="form_gen_pg.php">
<table border=1>
<tr><td>Host </td><td><input name=host value="127.0.0.1"></td></tr>
<tr><td>Banco </td><td><input name=database></td></tr>
<tr><td>Tabela </td><td><input name=table></td></tr>
<tr><td>Usuário </td><td><input name=user value=postgres></td></tr>
<tr><td>Senha </td><td><input type=password name=password value=postgres></td></tr>
<tr><td>Porta </td><td><input name=port value="5432"></td></tr>
<tr><td colspan="2" align="center"><input type=submit value="Gerar"></td></tr>
</table>
</form>
<hr>
Ribamar FS - <a href="http://ribafs.net">http://ribafs.net</a> - ribafs[]gmail.com - 25/10/2007<br>
</center>