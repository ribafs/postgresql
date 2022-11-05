<html><head><title>Applications Generator with PHP and PostgreSQL</title>
<LINK REL=stylesheet HREF="estilo.inc.css" TYPE="text/css">
</head>
<body onLoad="document.frmCrud.database.focus()">
<center>
<br><br><br>
<h2>Applications Generator with PHP and PostgreSQL</h2>
<h3>CRUD: Insert, Select, Update and Delete</h3>
<form method="post" name="frmCrud" action="generator.php">
<table border=1>
<tr><td>Host </td><td><input name=host value="127.0.0.1"></td></tr>
<tr><td>Banco </td><td><input name=database></td></tr>
<tr><td>Tabela </td><td><input name=table></td></tr>
<tr><td>Usuário </td><td><input name=user></td></tr>
<tr><td>Senha </td><td><input type=password name=password></td></tr>
<tr><td>Porta </td><td><input name=port value="5432"></td></tr>
<tr><td colspan="2" align="center"><input type=submit value="Generate"></td></tr>
</table>
</form>
<hr>
Ribamar FS - <a href="http://ribafs.tk">http://ribafs.tk</a> - ribafs[no]gmail.com - 19/12/2005<br>
Obs.: <font color=red><b>To databases with scheme use in Tables: schemename.tablename</font>
</center>