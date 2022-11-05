<select name="campo_cidade"> 
<?php 
include "conexao.inc.php";
   
    $sql = "SELECT * FROM interacoes"; 
    $sql_result = pg_query($sql); 
    while ($row = pg_fetch_array($sql_result)) 
    { 
        echo '<option value="'.$row[0].'">'.$row[1].'</option>'; 
    } 
?> 
</select> 
