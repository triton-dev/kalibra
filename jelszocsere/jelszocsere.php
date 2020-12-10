<?php
/*
 * Jelszó csere feldolgozás
 */
require_once '../inc/func.php';

$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_POST['mentes']) && $_POST['mentes'] != '') {
	
	$fhnev = $_SESSION['kalib_fhnev'];
	$regi = pg_escape_string($_POST['regi']);
	$uj1 = pg_escape_string($_POST['jelszo1']);
	$uj2 = pg_escape_string($_POST['jelszo2']);
	
	$q  = "select jelszocsere('$fhnev','$uj1','$uj2','$regi');";
	$res = $pg->query($q);
	$result = $res->fetch(PDO::FETCH_NUM)[0];
}

htmlHeader();
if ($result === true) {
	$_SESSION['kalib_alapjelszo'] = false;
	header("Location: /kalibra/msg/jelszocseremsg.php?m=t");
}
else {
	header("Location: /kalibra/msg/jelszocseremsg.php?m=f");
}
htmlFooter();
?>
