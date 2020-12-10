<?php
/*
 * Saját adatok módosítás feldolgozása
 * 
 */

require_once '../inc/func.php';

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_POST['cancel']) && $_POST['cancel']=='Mégsem') {
	header("Location: /kalibra/index.php");
}

if(isset($_POST['mentes']) && $_POST['mentes'] !='') {
	
	$fhnev = pg_escape_string($_POST['fhnev']);
	$vnev = pg_escape_string($_POST['vnev']);
	$knev = pg_escape_string($_POST['knev']);
	$hnev = pg_escape_string($_POST['hnev']);
	
	$q = "update felhasznalo set vnev='$vnev', knev='$knev', hnev='$hnev' ";
	$q .= "where fhnev='$_SESSION[kalib_fhnev]';";
	
	$stmt = $pg->exec($q);
	switch ($stmt) {
		case 1:
		case true:
			$q = "select nev, fhnev, szerep, alapjelszo from ";
			$q .= "v_felhasznalo_login where fhnev='$_SESSION[kalib_fhnev]';";
			$r = $pg->query($q);
			$row = $r->fetch(PDO::FETCH_NUM);
			$_SESSION['kalib_nev'] = $row[0];
			$_SESSION['kalib_fhnev'] = $row[1];
			$_SESSION['kalib_szerep'] = $row[2];
			$_SESSION['kalib_alapjelszo'] = $row[3];
			
			header("Location: /kalibra/msg/sajatadatmsg.php?m=1");
		break;
		default:
			header("Location: /kalibra/msg/sajatadatmsg.php?m=0");
		break;
	}
}

?>
