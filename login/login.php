<?php
/*
 * Bejelentkezés feldolgozása
 */
require_once '../inc/func.php';

if(isset($_POST['login'])) {
	$fhnev=pg_escape_string($_POST['fhnev']);
	$jelszo=pg_escape_string($_POST['jelszo']);
	
	$q = "select login('$fhnev','$jelszo');";
	$res = $pg->query($q);
	$r = $res->fetch(PDO::FETCH_NUM);
	
	if($r[0]===true) {
		$q = "select nev, fhnev, szerep, alapjelszo from ";
		$q .= "v_felhasznalo_login where fhnev='$fhnev';";
	//	sql($q);
		$r = $pg->query($q);
		$row = $r->fetch(PDO::FETCH_NUM);
		$_SESSION['kalib_nev'] = $row[0];
		$_SESSION['kalib_fhnev'] = $row[1];
		$_SESSION['kalib_szerep'] = $row[2];
		$_SESSION['kalib_alapjelszo'] = $row[3];
		header("Location: /kalibra/index.php");
	}
	else {
		header("Location: error.php");
	} 
}

?>
