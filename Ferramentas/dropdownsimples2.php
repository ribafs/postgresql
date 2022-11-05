<? 
include "conexao.inc.php";
    
$resultado=pg_query("select * from interacoes order by nome"); // lê e passa a consulta p/ resultado 
    	  echo "<option selected>Selecione</option>";
        while($linha=pg_fetch_array($resultado)) { // inicializa o while 
            echo "<option value=$linha[0]>$linha[1]</option>"; // carrega a combo com esse valor 
        } 
    echo "</select>"; // finaliza a combo 
?> 
