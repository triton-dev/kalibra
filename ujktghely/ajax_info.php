<?php

require_once '../inc/func.php';

if (isset($_GET['q']) && $_GET['q'] != '') {
	
	$hint = "";
	$ktghely = pg_escape_string($_GET['q']);
	$q = "select ktghely from koltseghely where ktghely ilike '$ktghely%' ";
	$q .= "order by 1 limit 5;";
	$res = $pg->query($q);
	while($row = $res->fetch(PDO::FETCH_NUM)) {
		$hint .= "$row[0]<br>";
	}
	
	echo $hint == "" ? "Nincs találat." : "Már létező költséghelyek:<br>$hint";
}

?>
