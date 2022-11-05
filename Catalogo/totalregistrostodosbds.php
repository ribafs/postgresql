<?php

$conexao=pg_connect("host=127.0.0.1 user=postgres password=postabir");

$sql="SELECT datname AS banco FROM pg_database ORDER BY datname";
$consulta=pg_query($conexao,$sql);

	$banco = array();
	$c=0;
	while ($data = @pg_fetch_object($consulta,$c)) {
		$cons=$data->banco;		

		$banco[] .= $cons;
	$c++;
	}

$sql2="SELECT n.nspname as esquema,c.relname as tabela  FROM pg_namespace n, pg_class c
  WHERE n.oid = c.relnamespace
    and c.relkind = 'r'     -- no indices
    and n.nspname not like 'pg\\_%' -- no catalogs
    and n.nspname != 'information_schema' -- no information_schema
  ORDER BY nspname, relname";

for ($x=0; $x < count($banco);$x++){
	if ($banco[$x] !="template0" && $banco[$x] != "template1" && $banco[$x] !="postgres"){
		$conexao2=pg_connect("host=127.0.0.1 dbname=$banco[$x] user=postgres password=postabir");
  		$consulta2=pg_query( $conexao2, $sql2 );		
  		

		while ($data = pg_fetch_object($consulta2)) {
			$esquematab=$data->esquema.'.'.$data->tabela;
  			$sql3="SELECT count(*) FROM $esquematab";
			$consulta3=pg_query($conexao2,$sql3);
			$res=@pg_fetch_array($consulta3);

			print 'Banco.Esquema.Tabela -> '.$banco[$x].'.'.$data->esquema.'.'.$data->tabela.' - Registro(s) - '.$res[0].'<br>';
			$total += $res[0];
		}
		
	}
}
	print "Total de Registro de todas as tabelas de todos os bancos ". $total;

	
?>    