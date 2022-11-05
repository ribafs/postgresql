<?php header("Content-Type: text/html;  charset=ISO-8859-1",true) ?>
<html><head><title>PostgreSQL - Curso Online</title></head>
<h3 align="center">PostgreSQL - Curso Online</h3>

<?php

$activefolder = $HTTP_GET_VARS["activefolder"];

require_once('../../FileDisplayClass.inc.php');

$fileDisplay = New FileDisplay("./");  // initiate new object

/*
Next we can set some of the variables to alter the way that the directory
contents are presented.
This is optional.  If you choose not to set them here, the defaults from
the class will be used.  All the variables declared at the beginning of
the class with 'show' in their names can be set to true or false.
*/

$fileDisplay->showperms = true;

?>

<?php
$fileDisplay->showContents($activefolder);
?>

<h4 align="center"> <?php echo 'Ribamar FS - ' . date('d/m/Y H:m:i');?> </h4>
