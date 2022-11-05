<?php
$conexao = pg_connect("host=localhost user=postgres password=postgres dbname=cliente") or die("Não foi possível conectar ao bd");

function combo_pg($tabela, $cp_armazena, $cp_mostra, $default=1){
global $conexao;
	$sql = "select $cp_armazena,$cp_mostra from $tabela order by $cp_armazena";
	$consulta = pg_query($conexao,$sql);
	$registros = pg_num_rows($consulta);
	if($registros==0)
	{
		echo "<script>alert('Nenhum registro foi encontrado');location='history.back()';</script>";
	}else{
		print "<select name=$descricao>";
		while ($campo = pg_fetch_row($consulta)){			
			if($campo[0]==$default){
				print "<option value=\"$campo[0]\" SELECTED>$campo[1]</option>\n";
			}else{
				print "<option value=\"$campo[0]\">$campo[1]</option>\n";			
			}
		}
		print "</select>";
	}	
}
// Testando:
combo_pg('clientes','id','nome',10);
?>