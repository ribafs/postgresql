<?php
// create database testes;
// create table popula(codigo serial primary key, valor numeric(6,3));

$con=pg_connect("host=localhost user=postgres password=postgres dbname=testes port=5433");

for($i = 0; $i <= 50000; $i++){
       $foo = mt_rand(0,10);
       $bar = mt_rand(0,999);
       $sql = "insert into popula(texto, valor) values($i,$foo.$bar);";  //$foo - parte inteira, ., e $bar a parte decimal
       pg_query($sql);
}

?>
