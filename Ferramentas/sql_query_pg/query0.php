<HTML><HEAD><TITLE> PHP SQL Code Tester - Livro Professional PHP Programming</TITLE>
</HEAD>
<BODY>
<!-- query.php -->
<?php
import_request_variables("gP");

$host=$host0;
$user=$user0;
$password=$password0;
$db=$dbname0;

?>
<FORM ACTION="query.php" METHOD=POST>
Selecione um Banco<br><br>
<SELECT NAME=database SIZE=1 >

<?php
     $con = pg_connect("dbname=$db host=$host user=$user password=$password");
     $rs = pg_query($con, "select datname from pg_database");
     $maxrows = pg_numrows($rs);
      	
	for ($i = 0; $i < $maxrows; $i++) 
	{
        	$row = pg_fetch_row($rs, $i);
		echo "<option value=$row[0]>$row[0]</option>";
        	//echo("$row[0]<br>\n");
        }
?>

</select><br>
Entre com a consulta a ser executada abaixo (em SQL)<BR><BR>
<TEXTAREA NAME="query" COLS=50 ROWS=10></TEXTAREA>
<BR><BR>
<INPUT TYPE=SUBMIT VALUE="Rodar">
</FORM>
</BODY>
</HTML>