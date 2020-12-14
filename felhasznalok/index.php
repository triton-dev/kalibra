<?php
/*
 * Felhasználók listája
 */
require_once '../inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_SESSION['kalib_alapjelszo']) && $_SESSION['kalib_alapjelszo'] === true) {
	header("Location: /kalibra/jelszocsere/index.php");
}


$q = "select nev,fhnev,szerep, case when aktivfelhasznalo then 'aktív' else 'zárolt' end as statusz, ";
$q .= "case when alapjelszo then 'alap' else 'saját' end as jelszo ";
$q .= "from v_felhasznalo_login order by nev;";



$fejlec ='Felhasználók listája';


htmlHeader();
btnBackTopSticky();

$res = $pg->query($q);
echo"
<table class='table table-bordered table-striped'>
  <thead class='text-center'>
	<tr class='bg-secondary'> 
		<th scope='col' colspan='6' class='text-center text-white'>$fejlec</th>
	</tr>
    <tr>
		<th scope='col'>
			Név
		</th>
		<th scope='col'>
				Felhasználónév
		</th>
		<th scope='col'>
			Szerep
		</th>
		<th scope='col'>
			Státusz
		</th>
		<th scope='col'>
			Jelszó státusz
		</th>
    </tr>
    </thead>
  <tbody>
";
while($row = $res->fetch(PDO::FETCH_ASSOC)) {
	$admin = '';
	$statusz = "class='table-warning text-center'";
	$jelszo = "class='table-warning text-center'";
	
	if($row['szerep'] == 'admin') {
		$admin = " class='table-danger'";
	}
	
	if($row['statusz'] == 'aktiv') {
		$statusz = "class='table-success text-center'";
	}
	
	if($row['jelszo'] == 'saját') {
		$jelszo = "class='table-success text-center'";
	}
	
echo"
	<tr $admin>
		<td>$row[nev]</td>
		<td>$row[fhnev]</td>
		<td>$row[szerep]</td>
		<td $statusz>$row[statusz]</td>
		<td $jelszo>$row[jelszo]</td>
    </tr>
";
}
echo "
	</tbody>
</table>
";

htmlFooter()
?>
