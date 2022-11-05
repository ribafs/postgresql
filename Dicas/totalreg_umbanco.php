<?php

$conexao=pg_connect("host=localhost dbname=banco user=postgres password=postgres");

$sql="SELECT n.nspname as esquema,c.relname as tabela  FROM pg_namespace n, pg_class c
  WHERE n.oid = c.relnamespace
    and c.relkind = 'r'     -- no indices
    and n.nspname not like 'pg\\_%' -- no catalogs
    and n.nspname != 'information_schema' -- no information_schema
  ORDER BY nspname, relname";

$consulta=pg_query($conexao,$sql);

$resultado=pg_fetch_array($consulta,0);


while ($data = pg_fetch_object($consulta)) {
// print $data->esquema.'<br />';
        //print $data->tabela.'<br />';
    $esquematab=$data->esquema.'.'.$data->tabela;
    $sql2="SELECT count(*) FROM $esquematab";
    $cons=pg_query($conexao,$sql2);
    $res=pg_fetch_array($cons);
    $total += $res[0];
}
print "Total de Registro de todas as tabelas do banco apoena ". $total;

?> 
