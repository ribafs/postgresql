<html><head><title>PostgreSQL - Curso Online</title></head>
<body bgcolor='seagreen'>
<!-- Este script mostra miniaturas das imagens do diretório atual,
como também exibe informações sobre cada imagem: nome, dimensões e tamanho em bytes.
Ainda exibe o tamanho total do diretório e a quantidade de arquivos recursivamente.
-->

<?php
$folder = '.';
$dir = getcwd();
DirStat($folder, 0);
chdir($dir);
$FolderSize = ByteSize($FolderSize);
$FileCount=$FileCount-2;
?>

<h4 align=center>http://pg.ribafs.net - <?php echo date('d/m/Y H:i:s') ." - $FileCount arquivos - $FolderSize";?></h4>

<?php
/** Dimensões originais da imagem: largura = $size[0], altura = $size[1]
  * Largura do thumbnail $larg (dado)
  * Altura do thumbnail, proporcional à largura entrada e às dimensões originais
  * A altura é calculada com a fórmula 
  * $alt = ($larg * $size[1])/$size[0];
  * 
  * Adaptação de Ribamar FS - http://ribafs.net
  */

$imagens='';
$dn = opendir('.');
while (false !== ($file = readdir($dn))) {
 if ($file == '.' || $file =='..' || $file =='index.php' || $file =='Thumbs.db'){
	//print "<a href=$file>$file</a><br>";
 }else{
	if (is_dir($file)){
		print "<img src='/imagens/diretorio.png'>&nbsp;<a href='$file?dir=dirname(__FILE__)'>$file</a><br>";
	}else{
		$tamanho = filesize($file);
		$m = 'bytes'; // Múltiplo
		if ($tamanho>1024) {
			$tamanho=round($tamanho/1024,2);
			$m = 'KB';
		} elseif($tamanho > 1024*1024){
			$tamanho = round(($tamanho/1024)/1024,2);
			$m = 'MB';
		}

		$imagens .=OutputThumbnail($file, $tamanho, $m);
	}
 } 
}

closedir($dn);

print '<br>'.$imagens;

function OutputThumbnail($image_file, $tamanho, $m)
{
  	if (file_exists($image_file))
   	{
   		$size = GetImageSize($image_file);
    		
   		if ($size[0] <=64) {
   			$larg=$size[0];    		
   		}elseif ($size[0] > 64 && $size[0] <= 200) {
   			$larg=64;
   		}elseif ($size[0] > 201 && $size[0] < 400) {
   			$larg=128;
   		}elseif ($size[0] > 401) {
   			$larg=256;
   		}
   			
   		if ($size[0] == 0) $size[0]=1;
    		
   		$alt= ($larg * $size[1])/$size[0];    		
   		   		
   		return "<a href=$image_file><img width=$larg height=$alt	src=$image_file border=0 
   			TITLE='$image_file - $larg x $alt - $tamanho $m'></a>&nbsp;&nbsp;";   		
   	}
}

?>

<?
/**
* As duas funções abaixo retornam o tamanho total de um diretório recursivamente
* e também a quantidade de arquivos e subdiretórios
* *************************************************
* PHP Freaks Code Library
* http://www.phpfreaks.com/quickcode.php
*
* Title: Directory Size
* Version: 1.0
* Author: Nathan Taylor aka(Lakario)
* Date: Saturday, 12/20/2003 - 12:34 PM
*
*
*
* NOTICE: This code is available from PHPFreaks.com code Library.
* This code is not Copyrighted by PHP Freaks.

*
* PHP Freaks does not claim authorship of this code.
*
* This code was submitted to our website by a user.
*
* The user may or may not claim authorship of this code.
*
* If there are any questions about the origin of this code,
* please contact the person who submitted it, not PHPFreaks.com!
*
* USE THIS CODE AT YOUR OWN RISK! NO GUARANTEES ARE GIVEN!
*
* SHAMELESS PLUG: Need WebHosting? Checkout WebHost Freaks:
* http://www.webhostfreaks.com
* WebHosting by PHP Freaks / The Web Freaks!
*/

// * Description / Example:
// *
// * This code will allow an individual to quickly obtain the size and number of files inside a 
// * directory recursively.
// *
// * It also includes a convenient byte value converter to kilobyte, megabyte, gigabyte, or
// * trilobyte accordingly.

?>

<?php
function DirStat($directory) {
	global $FolderCount, $FileCount, $FolderSize;

	chdir($directory);
	$directory = getcwd();
	if($open = opendir($directory)) {
		while($file = readdir($open)) {
			if($file == '..' || $file == '.') continue;
				if(is_file($file)) {
					$FileCount++;
					$FolderSize += filesize($file);
				} elseif(is_dir($file)) {
					$FolderCount++;
				}			
		}
		if($FolderCount > 0) {
			$open2 = opendir($directory);
			while($folders = readdir($open2)) {
				$folder = $directory.'/'.$folders;
				if($folders == '..' || $folders == '.') continue;
					if(is_dir($folder)) {
						DirStat($folder);
					}
				}
				closedir($open2);
			}
			closedir($open);
		}
}

function ByteSize($bytes) {
	$size = $bytes / 1024;
	if($size < 1024){
		$size = number_format($size, 2);
		$size .= 'KB';
	} else {
		if($size / 1024 < 1024) {
			$size = number_format($size / 1024, 2);
			$size .= 'MB';
		} elseif($size / 1024 / 1024 < 1024) {
			$size = number_format($size / 1024 / 1024, 2);
			$size .= 'GB';
		} else {
			$size = number_format($size / 1024 / 1024 / 1024,2);
			$size .= 'TB';
		}	
	}
	return $size;
}

?>