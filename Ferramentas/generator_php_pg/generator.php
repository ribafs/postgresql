<?php
/* Applications Generator with PHP and PostgreSQL.
 * This little utility genera CRUD (Select, Insert, Update and Delete) to a table. 
 * Ribamar FS - ribafs[no]gmail.com, 19/12/2005
 * http://ribafs.tk
*/

$host=$_POST["host"];
$database=$_POST["database"];
$table=$_POST["table"];
$user=$_POST["user"];
$password=$_POST["password"];
$port=$_POST["port"];

include "conexao.inc.php"; 

$include = "<?\ninclude \"con_".$table.".inc.php\";\n?>\n\n";

function createFile($file, $str){
	$fileopen = fopen($file, "w"); // Create the file, if not exist and overwrite if exist
	fwrite($fileopen,$str);
	fclose($fileopen);
}

function head($file){
	$cab = "<html><head><title>$file</title>\n";
	$cab .= "<LINK REL=\"stylesheet\" HREF=\"estilo.inc.css\" TYPE=\"text/css\">\n";
	$cab .= "</head>\n";
	$cab .= "<body><center><h2>$file</h2>\n";
	
	return $cab;
}
 
$res = pg_query($conexao, "select * from $table");
$numregs=pg_num_rows($res);
$i = pg_num_fields($res);   

if(!file_exists($table)) {mkdir($table);} 

$so = PHP_OS;

if ($so == "WINNT"){ // If in Windows NT and similares...
	if(file_exists("estilo.inc.css")) copy ("estilo.inc.css","$table\estilo.inc.css"); 
	exec('start xcopy *.gif ' . $table , $a, $a1);

	$fileind="$table\index.php";
	$filecon="$table\con_".$table.".inc.php";
	$fileins="$table\ins_".$table.".php";
	$fileinscod="$table\inscod_".$table.".php";
	$filesel1="$table\sel1_".$table.".php";
	$filesel1cod="$table\sel1cod_".$table.".php";
	$fileselall="$table\selall_".$table.".php";
	$fileupd="$table\upd_".$table.".php";
	$fileupd2="$table\upd2_".$table.".php";
	$fileupdcod="$table\updcod_".$table.".php";
	$filedel="$table\del_".$table.".php";
	$filedelcod="$table\delcod_".$table.".php";
}else{ // If in Linux and cia...
	if(file_exists("estilo.inc.css")) copy ("estilo.inc.css","$table/estilo.inc.css");
	exec('cp -R *.gif ' . $table);
	
	$fileind="$table/index.php";
	$filecon="$table/con_".$table.".inc.php";
	$fileins="$table/ins_".$table.".php";
	$fileinscod="$table/inscod_".$table.".php";
	$filesel1="$table/sel1_".$table.".php";
	$filesel1cod="$table/sel1cod_".$table.".php";
	$fileselall="$table/selall_".$table.".php";
	$fileupd="$table/upd_".$table.".php";
	$fileupd2="$table/upd2_".$table.".php";
	$fileupdcod="$table/updcod_".$table.".php";
	$filedel="$table/del_".$table.".php";
	$filedelcod="$table/delcod_".$table.".php";
}

/* conection file ($filecon) */

$con = "<?\n";
$con .="\$conexao = pg_connect(\"dbname=$database user=$user password=$password host=$host port=$port\");\n\n";
$con .="if (!\$conexao) echo \"Error: database conection fail!\"; ";
$con .= "\n?>";

createFile($filecon, $con);

/* Index.php ---------------------------------------------------------------------------------- */

$ind = head($fileind);

$ind .="<center><table border=\"1\">\n";
$ind .="<tr><td><a href=\"ins_".$table.".php\">Insert a Register</a></td></tr>\n";
$ind .="<tr><td><a href=\"sel1_".$table.".php\">Query One</a></td></tr>\n";
$ind .="<tr><td><a href=\"selall_".$table.".php\">Query All</a></td></tr>\n";
$ind .="<tr><td><a href=\"upd_".$table.".php\">Update</a></td></tr>\n";
$ind .="<tr><td><a href=\"del_".$table.".php\">Delete</a></td></tr>\n";
$ind .="</table></center></body></html>\n";

createFile($fileind, $ind);

/* Form Insert ($fileins) ---------------------------------------------------------------------- */

$ins=head($fileins);

$ins .="<form name=\"frm_".$table."\" method=\"post\" action=\"inscod_".$table.".php\">\n";
$ins .="<table border=\"1\">\n";

for ($j = 1; $j <= $i; $j++) {
	$fieldname = pg_field_name($res, $j-1);
	$inimaiusc=ucfirst($fieldname);
		
	$ins .="\t<tr><td>$inimaiusc</td><td>";
	$ins .="<input name=\"$fieldname\" type=\"text\"></td></tr>\n";	
}

$ins .="<tr><td><input type=\"submit\" value=\"Insert\"></td></tr>";
$ins .="</table>\n</form></body></html>";
$ins .="<a href=\"#\" onclick=\"history.back()\">Back</a>\n";

createFile($fileins, $ins);

/* Código insert --------------------------------------------------------------------------- */

$inscod = $include;

$inscod .= head($fileins);
$inscod .= "<?\n";

for ($j = 1; $j <= $i; $j++) {
	$fieldname = pg_field_name($res, $j-1);
	$inimaiusc=ucfirst($fieldname);
	$inscod .="\$$fieldname = \$_POST['".$fieldname."'];\n";
}

   $inscod .="\n\$strInsert = \"INSERT INTO $table (";
   for ($j = 0; $j < $i; $j++) {
      $fieldname = pg_field_name($res, $j);
		if ($j < $i-1)       
     	$inscod .= "$fieldname,";
     	else
     	$inscod .= "$fieldname";
	}
	   $inscod .= ")";	 

   	$inscod .= " VALUES (";
   for ($j = 0; $j < $i; $j++) {
   	$fieldname = pg_field_name($res, $j);
		if ($j < $i-1){ 
			if(is_numeric($fieldname))
     			$inscod .= "\$$fieldname,";
     		else
     			$inscod .= "'\$$fieldname',";     
     	}else{
     		if(is_numeric($fieldname))
     			$inscod .= "\$$fieldname";
     		else
     			$inscod .= "'\$$fieldname'";
     	}
	}
	   $inscod .=")\";\n";	 	 
	   
$inscod .="\n//For bigger robustness of the code we must test the execution of any function that can generate error!";
$inscod .="\n\$insert = pg_query(\$conexao, \$strInsert);\n\n";
$inscod .="if (\$insert){\n\techo \"<center>Successfully inserted register!<br>\";\n}else{\n\techo \"<center>Error: fail to insert register!<br>\";\n}";
$inscod .="\necho \"<a href=\\\"#\\\" onclick=\\\"history.go(-2)\\\">Back</a></center>\";";
$inscod .="\n?>";

createFile($fileinscod, $inscod);

/* Query one register ($filesel1cod) ------------------------------------------ */

$sel1 = head($filesel1);

$sel1 .="<form name=\"frm_sel1.$table\" method=\"post\" action=\"sel1cod_".$table.".php\">\n";
$sel1 .="<table border=\"1\">\n";

	$fieldname = pg_field_name($res, 0);
	$inimaiusc=ucfirst($fieldname);
	
	$sel1 .="<tr><td colspan=\"2\">Enter the $inimaiusc to query </td></tr>\n";
	$sel1 .="<tr><td>$inimaiusc</td><td>";
	$sel1 .="<input name=\"$fieldname\" type=\"text\"></td></tr>\n";
	
$sel1 .="<tr><td colspan=\"2\" align=\"center\"><input type=\"submit\" value=\"Query\"></td></tr>";
$sel1 .="</table>\n</form></body></html>";
$sel1 .="<a href=\"#\" onclick=\"history.back()\">Back</a>\n";

createFile($filesel1, $sel1);

/* Query one  Code ($filesel1cod) -------------------------------------------------- */

$sel1cod = $include;
$sel1cod .= head($filesel1cod);

$sel1cod .="<?\n";
$fieldname = pg_field_name($res, 0); // Change of 0 to other,if your primary_key not is the field 0
$sel1cod .= "\$$fieldname = \$_POST['".$fieldname."'];\n";
$fieldnamep = $fieldname;
$sel1cod .= "\n\$strCons1 = \"SELECT * FROM $table WHERE $fieldname = '\$".$fieldnamep."' \";\n";
	   
$sel1cod .= "\n\$cons1 = pg_query(\$conexao, \$strCons1);\n\n";
$sel1cod .= "\$numregs = pg_num_rows(\$cons1);\n";
$sel1cod .= "if (\$numregs == 0){\n";
$sel1cod .= "\techo 'Sorry! Register not found!';\n";
$sel1cod .= "} else if(\$numregs > 0) {\n";

for ($j = 1; $j <= $i; $j++) {
	$fieldname = pg_field_name($res, $j-1);
	$sel1cod .= "\t\$$fieldname = pg_fetch_result(\$cons1,0,'".$fieldname."');\n";
}
$sel1cod .="}\n";

$sel1cod .= "?>\n<center><h2>Registers View!</h2>\n";
$sel1cod .= "<table border='1'>\n";

for ($j = 1; $j <= $i; $j++) {	
	$fieldname = pg_field_name($res, $j-1);
	$sel1cod .="<tr><td>$fieldname</td><td><? echo \$$fieldname ?></td></tr>\n";
}

$sel1cod .= "</table></center>\n";
$sel1cod .= "<center><a href=\"#\" onclick=\"history.go(-2)\">Back</a></center>\n\n<?";

$sel1cod .= "if (!\$cons1) echo \"Erro na Consulta!\";exit;";
$sel1cod .= "\n?>";

createFile($filesel1cod, $sel1cod);

/* Query All Registers ($fileselall) ------------------------------------------ */

$selall = $include;

$selall .= head($fileselall);
$selall .= "<?\n";
$selall .= "/* Original Paging in http://www.php-mysql-tutorial.com/php-mysql-paging.php */\n\n";
$selall .= "// how many rows display per page \n";
$selall .= "\$rowsPerPage = 10; \n\n";

$selall .= "// for defaul display the first page \n";
$selall .= "\$pageNum = 1; \n\n";

$selall .= "// if \$_GET['page'] is definede, use this to page numbers \n";
$selall .= "if(isset(\$_GET['page'])) \n";
$selall .= "{ \n";
$selall .= "    \$pageNum = \$_GET['page']; \n";
$selall .= "} \n\n";

$selall .= "// counting the offset \n";
$selall .= "\$offset = (\$pageNum - 1) * \$rowsPerPage; \n\n";

$fieldname0=pg_field_name($res,0);

$selall .= "\$strConst = \"SELECT * FROM $table ORDER BY $fieldname0 LIMIT \$rowsPerPage OFFSET \$offset\";\n";
$selall .= "\$const = pg_query(\$conexao, \$strConst);\n\n";

$selall .= "if (!\$const) {\n";
$selall .= "echo \"Error: fail in query!\";exit;\n";
$selall .= "}\n";
$selall .= "\$numregs = pg_num_rows(\$const);\n\n";

$selall .= "if (\$numregs == 0){\n";
$selall .= "	echo \"Sorry! Register not found!\";\n";
$selall .= "} else if(\$numregs > 0) {\n\n";

$selall .="\n\necho \"<center><h2>Registers View!</h2>\";\n";
$selall .="echo \"<table border=\\\"1\\\"><tr>\";\n";

$selall .="echo \"";
	for ($j = 1; $j <= $i; $j++) {
		$fieldname = pg_field_name($res, $j-1);
		$selall .="<td><b>$fieldname</b></td>";		
	}
$selall .="\";\n";	

$selall .="echo \"</tr>\";\n\n\t\$i2=0;\n";
$selall .="\twhile (\$i2<\$numregs){\n";
	for ($j = 1; $j <= $i; $j++) {
		$fieldname = pg_field_name($res, $j-1);		
		$selall .="\t\t\$$fieldname = pg_fetch_result(\$const,\$i2,\"".$fieldname."\");\n";				
	}

	$selall .="\t\techo \"<tr>";
	for ($j = 1; $j <= $i; $j++) {
		$fieldname = pg_field_name($res, $j-1);
		$selall .="<td>\$$fieldname</td>";		
	}
	$selall .="</tr>\";\n";

$selall .="\t\$i2++;\n";
$selall .="\t}\n\n";

$selall .="echo \"</table></center>\";\n\n";

$selall .="// how many registers in table \n";
$selall .="\$query   = \"SELECT COUNT($fieldname0) AS numrows2 FROM $table\";\n"; 
$selall .="\$result  = pg_query(\$query) or die('Error, query fail');\n"; 
$selall .="\$row     = pg_fetch_array(\$result, PG_ASSOC); \n";
$selall .="\$numrows2 = \$row['numrows2']; \n\n";

$selall .="// how many pages in paging? \n";
$selall .="\$maxPage = ceil(\$numrows2/\$rowsPerPage); \n\n";

$selall .="// print access link to each page \n\n";

$selall .="\$self = \$_SERVER['PHP_SELF']; \n";
$selall .="\$nav = ''; \n\n";

$selall .="for(\$page = 1; \$page <= \$maxPage; \$page++) \n";
$selall .="{ \n";
$selall .="    if (\$page == \$pageNum) \n";
$selall .="    { \n";
$selall .="        \$nav .= \" \$page \";   // do not require create a link to current page \n";
$selall .="    } \n";
$selall .="    else \n";
$selall .="    { \n";
$selall .="        \$nav .= \" <a href=\\\"\$self?page=\$page\\\">\$page</a> \";\n"; 
$selall .="    }\n";
$selall .="} \n\n";

$selall .="// create links Previous and Next more the link to First and the Last \n\n";

$selall .="if (\$pageNum > 1) \n";
$selall .="{ \n";
$selall .="    \$page = \$pageNum - 1; \n";
$selall .="    \$prev = \" <a href=\\\"\$self?page=\$page\\\"><img src=\\\"reg_prev.gif\\\" TITLE=\\\"Previous\\\"></a> \"; \n\n";
     
$selall .="    \$first = \" <a href=\\\"\$self?page=1\\\"><img src=\\\"reg_first.gif\\\" TITLE=\\\"First Page\\\"></a> \"; \n";
$selall .="} else { \n";
$selall .="    \$prev = \" <a href=\\\"#\\\"><img src=\\\"reg_prevdisab.gif\\\" TITLE=\\\"Previous\\\"></a> \";\n"; 
$selall .="    \$first = \" <a href=\\\"#\\\"><img src=\\\"reg_firstdisab.gif\\\" TITLE=\\\"First Page\\\"></a>\";\n";
$selall .="} \n\n";

$selall .="if (\$pageNum < \$maxPage) \n";
$selall .="{ \n";
$selall .="    \$page = \$pageNum + 1; \n";
$selall .="    \$next = \" <a href=\\\"\$self?page=\$page\\\"><img src=\\\"reg_next.gif\\\" TITLE=\\\"Next\\\"></a> \"; \n\n";
     
$selall .="    \$last = \" <a href=\\\"\$self?page=\$maxPage\\\"><img src=\\\"reg_last.gif\\\" TITLE=\\\"Last Page\\\"></a> \"; \n";
$selall .="} else { \n";
$selall .="    \$next = \" <a href=\\\"#\\\"><img src=\\\"reg_nextdisab.gif\\\" TITLE=\\\"Next\\\"></a> \";\n"; 
$selall .="    \$last = \" <a href=\\\"#\\\"><img src=\\\"reg_lastdisab.gif\\\" TITLE=\\\"Last Page\\\"></a>\";\n";
$selall .="} \n\n";

$selall .="// mostra os links de navegação \n";
$selall .="echo \$first . \$prev . \$nav . \$next . \$last; \n";

$selall .="\n?>";
$selall .= "<br><br><center><a href=\"#\" onclick=\"history.back()\">Back</a></center>\n";
$selall .="<?\n";
$selall .="}\n";
$selall .="\n?>";
	   
createFile($fileselall, $selall);

/* Form1 of Update Registers ($fileupd) -------------------------------------- */

$upd = head($fileupd);

$upd .="<form name=\"frm_upd.$table\" method=\"post\" action=\"upd2_".$table.".php\">\n";
$upd .="<table border=\"1\">\n";

	$fieldname = pg_field_name($res, 0);
	$inimaiusc=ucfirst($fieldname);
	
	$upd .="<tr><td>Enter the $inimaiusc to Update </td></tr>\n";
	$upd .="<tr><td>$inimaiusc: ";
	$upd .="<input name=\"$fieldname\" type=\"text\"></td></tr>\n";
	
$upd .="<tr><td><input type=\"submit\" value=\"Update\"></td></tr>";
$upd .="</table>\n</form></body></html>";
$upd .= "<center><a href=\"#\" onclick=\"history.back()\">Back</a></center>\n";

createFile($fileupd, $upd);

/* Second Form of Update ($fileupd2) ----------------------------------------- */

$upd2 = $include;

$upd2 .= head($fileupd2);
$upd2 .= "<?\n";
$fieldname = pg_field_name($res, 0);
$upd2 .="\t\$$fieldnamep = \$_POST[\"".$fieldname."\"];\n";

$upd2 .="\t\$strUpd2 = \"SELECT * FROM $table WHERE $fieldname =\$$fieldnamep\";\n";   
$upd2 .="\t\$Upd2 = pg_query(\$conexao, \$strUpd2);\n\n";

for ($j = 1; $j <= $i; $j++) {
	$fieldname = pg_field_name($res, $j-1);
	if($j==1){
		$upd2 .="\t\$$fieldname = pg_fetch_result(\$Upd2,0,$fieldname);\n";
	}else{
		$upd2 .="\t\$$fieldname = pg_fetch_result(\$Upd2,0,'".$fieldname."');\n";
	}
}

$upd2 .="?>\n<center><h2>Register View!</h2>\n";
$upd2 .="<form name=\"frmUpd_".$table."\" method=\"POST\" action=\"updcod_".$table.".php\">\n";
$upd2 .="<table border=\"1\">\n";

for ($j = 1; $j <= $i; $j++) {	
	$fieldname = pg_field_name($res, $j-1);
	$upd2 .="<tr><td><b>$fieldname</b></td><td><input type=\"text\" name=\"$fieldname\" value=\"<? echo \$$fieldname ?>\"></td></tr>\n";
}

$upd2 .="<tr><td><input type=\"submit\" value=\"Update\"></td></tr>";
$upd2 .="</table>\n</form></body></html>";
$upd2 .= "<center><a href=\"#\" onclick=\"history.go(-2)\">Back</a></center>\n";

createFile($fileupd2, $upd2);

/* Update Code ($fileupdcod) ------------------------------------------------ */

$updcod = $include;

$updcod .= head($fileupd2);

$updcod .= "\n<?\n";

for ($j = 1; $j <= $i; $j++) {
	$fieldname = pg_field_name($res, $j-1);
	$inimaiusc=ucfirst($fieldname);
	$updcod .="\$$fieldname = \$_POST[\"".$fieldname."\"];\n";
}

   $updcod .="\n\$strUpdate = \"UPDATE $table SET ";
   for ($j = 0; $j < $i; $j++) { 
      $fieldname = pg_field_name($res, $j);
   	if ($j==0) $fieldname1=$fieldname;

		if ($j < $i-1){		
			if($j==0)
     			$updcod .= "$fieldname = \$$fieldname, ";     		
     		else
     			$updcod .= "$fieldname = '\$$fieldname', ";
     	}else{
     		$updcod .= "$fieldname = '\$$fieldname' ";
     	}
	}
	   $updcod .="WHERE $fieldname1 = \$$fieldname1\";\n";	 	 
	   
$updcod .="\n\$update = pg_query(\$conexao, \$strUpdate);\n\n";
$updcod .="if (\$update)\n{\n\techo \"<center>Sucesufully update register!<br>\";\n}else{\n\techo \"<center>Error: Update fail!<br>\";
			\n\texit;\n}";
$updcod .= "?>\n<a href=\"#\" onclick=\"history.go(-3)\">Back</a></center>\n";

createFile($fileupdcod, $updcod);

/* Form Delete ($filedel) ----------------------------------------------------------- */

$del = head($filedel);

$del .= "<h3>Enter value to Delete!</h3>\n";
$del .= "<form name=\"frm_".$table."\" method=\"post\" action=\"delcod_".$table.".php\">\n";
$del .= "<table border=\"1\">\n";

	$fieldname = pg_field_name($res, 0);
	$inimaiusc=ucfirst($fieldname);	
	$del .="\t<tr><td>$inimaiusc: ";
	$del .="<input name=\"$fieldname\" type=\"text\"></td></tr>\n";	

$del .="<tr><td><input type=\"submit\" value=\"Delete\"></td></tr>";
$del .="</table>\n</form></body></html>\n";
$del .= "<a href=\"#\" onclick=\"history.back()\">Back</a></center>\n";

createFile($filedel, $del);

/* Código de Exclusão ($filedelcod) ------------------------------------------------- */

$delcod = $include;
$delcod .= head($filedelcod);
$delcod .= "<?\n";

	$fieldname = pg_field_name($res, 0);
	$inimaiusc=ucfirst($fieldname);
	$delcod .="\$$fieldname = \$_POST['".$fieldname."'];\n";

   $delcod .="\n\$strDelete = \"DELETE FROM $table WHERE $fieldname= '\$$fieldname'\";\n\n";	 	 
	   
$delcod .="\n\$delete = pg_query(\$conexao, \$strDelete);\n\n";
$delcod .="if (\$delete)\n{\n\techo \"<center>Sucessfully delete register!<br>\"; \n}else{\n\techo \"<center>Error: fail to delete!<br>\";\n\texit;\n}";
$delcod .= "?>\n<a href=\"#\" onclick=\"history.go(-2)\">Back</a></center>\n";

createFile($filedelcod, $delcod);

/* -----------------------------------------------------------*/
echo "<b>Generated Files:<br><br>".$fileind."<br>".$fileins."<br>".$filecon."<br>"
.$fileinscod."<br>".$filesel1."<br>".$fileselall."<br>".$fileupd."<br>".$fileupd2."<br>"
.$fileupdcod."<br>".$filedel."<br>".$filedelcod."</b>";

?> 