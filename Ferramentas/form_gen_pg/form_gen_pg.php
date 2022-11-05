<?php
/* Form Generator with PHP and PostgreSQL.
 * Ribamar FS - ribafs[]gmail.com, 25/10/2007
 * http://ribafs.net
*/

$host=$_POST["host"];
$database=$_POST["database"];
$table=$_POST["table"];
$user=$_POST["user"];
$password=$_POST["password"];
$port=$_POST["port"];

$conexao = pg_connect("dbname=$database user=$user password=$password host=$host port=$port");   
if(!conexao) echo "Error: connection to database Fail!";

$res = pg_query($conexao, "select * from $table");
$numregs=pg_num_rows($res);
$i = pg_num_fields($res);   


/* Adaptação da função encontrada no manual do PHP
Autor: r dot galovic at r-3 dot at
mysql_field_len () function and more for postgres ...

problems ...
* pg_field_prtlen ... gives the actual size of the field back (it shows the count of the content allready inside the field - not the possible max-len)
* pg_filed_size ... can't be used for varchar or bpchar fields

...but there is a way to get the real-max-length of a field in postgreSQL via the system tables:
*/

function SQLConstructFieldsInfo($TABLE, $DBCON)
{
    $s="SELECT a.attname AS name, t.typname AS type, a.attlen AS size, a.atttypmod AS len, a.attstorage AS i
    FROM pg_attribute a , pg_class c, pg_type t
    WHERE c.relname = '$TABLE' 
    AND a.attrelid = c.oid AND a.atttypid = t.oid";
   
    if ($r = pg_query($DBCON,$s))
    {
        $i=0;
        while ($q = pg_fetch_assoc($r))
        {
               $a[$i]["type"]=$q["type"];
               $a[$i]["name"]=$q["name"];
               if($q["len"]<0 && $q["i"]!="x")
               {
                   // in case of digits if needed ... (+1 for negative values)
                   $a[$i]["len"]=(strlen(pow(2,($q["size"]*8)))+1);
               }
               else
               {
                   $a[$i]["len"]=$q["len"]-4;
               }
               $a[$i]["size"]=$q["size"];
            $i++;           
        }        
        return $a;
    }
    return null;
}

$RET=SQLConstructFieldsInfo($table, $conexao);

/* Form Insert ($fileins) ---------------------------------------------------------------------- */

$ins .="<form name=\"frm_".$table."\" method=\"post\" action=\"inserir_".$table.".php\">\n";
$ins .="<table border=\"1\">\n";

for ($j = 1; $j <= $i; $j++) {
	$fieldname = pg_field_name($res, $j-1);
    $l=$RET[$j+5]["len"];
    if ($l>1000) $l=14;
	
	$inimaiusc=ucfirst($fieldname);
		
	$ins .="\t<tr><td>$inimaiusc</td><td>";
	$ins .="<input name=\"$fieldname\" type=\"text\" size=\"$l\" maxlength=\"$l\"></td></tr>\n";	
}

$ins .="<tr><td><input type=\"submit\" value=\"Inserir\"></td></tr>";
$ins .="</table>\n</form></body></html>";

/* Código insert --------------------------------------------------------------------------- */

$inscod = $include;

$inscod .= "<?php\n";

$inscod .="
\$host='".$_POST['host']."';
\$user='".$_POST['user']."';
\$password='".$_POST['password']."';
\$dbname='".$_POST['database']."';

\$conexao = pg_connect(\"host=$host user=$user password=$password dbname=$dbname\");
if(!conexao) die(\$pg_last_error.\"Error: Falha ao conectar ao banco $db\");
";

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
	   
$inscod .="\n";
$inscod .="\n\$insert = pg_query(\$conexao, \$strInsert);\n\n";
$inscod .="if (\$insert){\n\techo \"<center>Registro Inserido com sucesso!<br>\";\n}else{\n\techo \"<center>Erro: Falha ao inserir o registro!<br>\";\n}";
$inscod .="\n?>";

function createFile($file, $str){
	$fileopen = fopen($file, "w"); // Create the file, if not exist and overwrite if exist
	$f=fwrite($fileopen,$str);
	fclose($fileopen);
	if ($f) return true;
}

$form=createFile("gerados\form_".$table.".php", $ins);

$form=createFile("gerados\inserir_".$table.".php", $inscod);


if ($form){
	print "<h2>Arquivos \"gerados\form_$table.php\" e \"gerados\inserir_$table.php\".";
}else{
	print "Erro na criação dos arquivos!";
}	

?> 