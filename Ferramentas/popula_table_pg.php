<?php
/** Rotina para popular tabela do PostgreSQL com massa de testes
  * Colaboração de Ribamar FS - http://ribafs.net - 14/03/2007
  * Requer remoção da chave primária antes da execução.
  */ 
?>

<html><head><title>Inserir Registros de Teste</title></head>
<body bgcolor=''>
<h2 align=center>Cadastrar Tabela do PostgreSQL com Massa de Testes</h2>
<h3 align=center><font color=red>Remova chave primária da tabela, antes de executar</font></h3>
<h4 align=center>Observe que nem todos os tipos de dados foram contemplados, alguns ficarão como string</h4>

<table align=center>
<form method='POST' name=frmIns action='popula_table_pg.php'>

<tr><td>Host</td><td><input type=text name='host' value='127.0.0.1'></td></tr>
<tr><td>Banco</td><td><input type=text name='banco' value='cliente'></td></tr>
<tr><td>Usuário</td><td><input type=text name='usuario' value='postgres'></td></tr>
<tr><td>Senha</td><td><input type=text name='senha' value='postgres'></td></tr>
<tr><td>Tabela</td><td><input type=text name='tabela' value='clientes'></td></tr>
<tr><td>Registros</td><td><input type=text name='registros' value=5></td></tr>
<tr><td></td><td><input type=submit name='popular' value='Popular'></td></tr>
</form>
</table>
</body>
</html>

<?php
if(isset($_POST['popular'])){
	$host=$_POST['host'];
	$banco=$_POST['banco'];
	$usuario=$_POST['usuario'];
	$senha=$_POST['senha'];
	$tabela=$_POST['tabela'];
	$registros=$_POST['registros'];

	$conexao=pg_connect("host=$host user=$usuario password=$senha dbname=$banco port=5432");
	if (!$conexao){
		die('Erro ao conectar ao banco<br>'.pg_last_error($conexao));
	}
	$str="SELECT * FROM $tabela";
	$consulta= pg_query($conexao,$str);
	$nc=pg_num_fields($consulta);
	$nr=pg_num_rows($consulta);

   $n='';//numericos (int, tinyint, smallint, bigint, etc)
   $r=''; //reais (float e double)
   $s="'";//strings
   $d=date('Y-m-d'); //datas
   $dt=date('Y-m-d H:i:s');//datatimes
   $o=''; //outros

   	$inscod .="INSERT INTO $tabela (";
   	for ($j = 0; $j < $nc; $j++) {
      $campo = pg_field_name($consulta, $j);
		if ($j < $nc-1)	$inscod .= "$campo,";
     	else $inscod .= "$campo";
	}
	$inscod .= ")";	 
    $inscod .= " VALUES (";

   for ($j = 0; $j < $nc; $j++) {   
   $tam   = pg_field_size($consulta, $j);
   if($tam == -1) $tam=20; //Caso queira limitar os campos ao máximo de 20 posições
		if ($j < $nc-1){ 
			switch (pg_field_type($consulta, $j)){
				case 'int4':
					$n=str_pad($n,$tam,'12345679890');
					$inscod .= "$n,";
					break;
     			case 'float4':
					$r=str_pad($r,$tam,'1234567890');
					$inscod .= "$r,";
					break;
				case 'bpchar':
				case 'varchar':
					$s=str_pad($s,$tam,"abcdefghijklmnopqrstuvxyz");
					$inscod .= "$s',";
					break;
				case 'date':
		 		    $inscod .= "'$d',";
					break;
				case 'timestamp':
					$inscod .= "'$dt',";
					break;
				case 'text':
					$inscod .= "'$t'";
					break;
				default:
					$o=str_pad($o,$tam,"abcdefghijklmnopqrstuvxyz");
					$inscod .= "'$o',";
					break;
			}
     	}else{
     		switch (pg_field_type($consulta, $j)){
				case 'int4':
					$n=str_pad($n,$tam,'1234567890');
					$inscod .= "$n";
					break;
     			case 'float4':
					$r=str_pad($r,$tam,'1234567890');
					$inscod .= "$r";
					break;
				case 'bpchar':
				case 'varchar':
					$s=str_pad($s,$tam,"abcdefghijklmnopqrstuvxyz");
					$inscod .= "$s'";
					break;
				case 'date':
					$inscod .= "'$d'";
					break;
				case 'timestamp':
					$inscod .= "'$dt'";
					break;
				case 'text':
					$inscod .= "'$t'";
					break;
				default:
					$o=str_pad($o,$tam,"abcdefghijklmnopqrstuvxyz");
					$inscod .= "'$o'";
					break;
     		}
     	}
     	
	}
    $inscod .=");";	
	
    for($r=1;$r<=$registros;$r++){	   
		//echo  $inscod;
	   	if(!pg_query($conexao,$inscod)) die ("Erro na inclusão<br>".pg_last_error($conexao));
    }	   
}
?>
