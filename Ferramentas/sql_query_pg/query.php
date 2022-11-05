<HTML><HEAD><TITLE> PHP SQL Code Tester </TITLE>
<BODY>
<!-- query.php -->
<?php
import_request_variables("gP");
$user="postgres";
$host="localhost";
$password="postabir";
$db=$database;

pg_connect("host=$host user=$user password=$password dbname=$db port=5432");
$result = stripSlashes($query) ;
$result = pg_query($query);
?>

Resultados da Consulta <B><?php echo($query); ?></B><HR>
<?php
if ($result == 0){
	echo("<B>Error " . pg_last_error()."</B>");
}elseif (pg_num_rows($result) == 0){
	echo("<B>Consulta Executada com Sucesso!</B>");
}else{
	?>
	<TABLE BORDER=1>
	<THEAD>
	<TR>
	<?php
	for ($i = 0; $i < pg_num_fields($result); $i++) {
		echo("<TH>" . pg_field_name($result,$i) . "</TH>");
	}
	?>
	</TR>
	</THEAD>
	<TBODY>
	<?php
	for ($i = 0; $i < pg_num_rows($result); $i++) {
		echo("<TR>");
		$row_array = pg_fetch_row($result);
			for ($j = 0; $j < pg_num_fields($result); $j++) {
				echo("<TD>" . $row_array[$j] . "</TD>");
			}
		echo("</TR>");
	}
	?>
	</TBODY>
	</TABLE>
	<?php
}
?>
<HR><BR>
<FORM ACTION=index.php METHOD=POST>
<INPUT TYPE=SUBMIT VALUE="Nova Consulta">
</FORM>
</BODY>
</HTML>