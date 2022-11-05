<?php

/** Autor: Ribamar FS - http://ribafs.net
  *	Função para aqueles campos que desejamos oferecer uma combo, tipo: sexo, cor, dias da semana, etc.
  *
  * Exemplo de uso: Veja na seção default do módulo Engenharia - Serviços ou como mostrado abaixo:
  *
  * echo "<td>Cancelado?<select name=cancelado>";   
  * combo_campo ("$cancelado","s,n","Sim,Não")	   
  * echo "</select></td>";
  */

function combo_campo($campo,$options, $rotulos){
	$sel="";
	$opt=explode(",",$options);
	$rot=explode(",",$rotulos);
	for ($x=0;$x<count($opt);$x++){
		if ($campo==$opt[$x]) {
			$sel="SELECTED";
		}else{
			$sel="";
		}
	}

	for ($x=0;$x<count($rot);$x++){
		$str .="<option value=$opt[$x] $sel>$rot[$x]</option>";
	}
	return print $str;
}


/**** combo_campos_pg - Popular combo com resultado de consulta, exibindo um campo *****
Adaptação de Ribamar FS de código encontrado em http://www.web-max.ca/PHP/postgres_2.php 
Exemplo de uso (veja que precisa do início e final do Select):

echo "<select name=cod_interacao>";
$query = "select * from interacoes order by nome";
combo_campos_pg($conexao, $cod_interacao, $query, $blank="Selecione");
echo "</select>";
*****/

function combo_campos_pg($conexao,$selected,$query,$blank){
    if($blank){
        print("<option select value=\"0\">$blank</option>");
    }
    $resultID = pg_query($conexao,$query);
	if (!$resultID){
		?><script>alert("Erro na consulta! Detalhes abaixo!")</script><?
		echo pg_last_error($conexao);
		exit;
	}

    $num       = pg_num_rows($resultID); 

	if ($num <=0){
		?><script>alert("Nenhum registro cadastrado!")</script><?
		echo pg_last_error($conexao);
		exit;
	}
    for ($i=0;$i<$num;$i++) {
        $row = pg_fetch_row($resultID,$i);
        
		if (!$row){
		?><script>alert("Erro na consulta! Detalhes abaixo!")</script><?
		echo pg_last_error($conexao);
			exit;
		}

        if($row[0]==$selected)$dtext = "selected";
        else $dtext = "";
    
        print("<option $dtext value=\"$row[0]\">$row[1]</option>");
    }
}


?>