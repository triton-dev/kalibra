<?php
/*
 * AJAX feldolgozás új költséghelyhez
 */

require_once '../inc/func.php';

$hint="";

if(isset($_GET['q']) && $_GET['q'] != '') {
	$ktghely = pg_escape_string($_GET['q']);
	$q = "select ktghely from koltseghely where ktghely ilike '$ktghely%' limit 5;";
	//sql($q);
	$stmt = $pg->query($q);
	while($row=$stmt->fetch(PDO::FETCH_NUM)){
		$hint .= "$row[0], ";
	}
	echo $hint=="" ? "Nincs ilyen költséghely" : $hint;
}
?> 
