<?php
/*
 * Költségehlyek listája
 */
require_once '../inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_SESSION['kalib_alapjelszo']) && $_SESSION['kalib_alapjelszo'] === true) {
	header("Location: /kalibra/jelszocsere/index.php");
}

if(isset($_GET['o'])) {
	switch($_GET['o']) {
		case 'ka':
			$orderby = "order by ktghely asc, statusz asc";
		break;
		case 'kd':
			$orderby = "order by ktghely desc, statusz asc";
		break;
		case 'na':
			$orderby = "order by ktghelynev asc, statusz asc";
		break;
		case 'nd':
			$orderby = "order by ktghelynev desc, statusz asc";
		break;
		case 'sa':
			$orderby = "order by statusz asc, ktghely asc";
		break;
		case 'sd':
			$orderby = "order by statusz desc, ktghely asc";
		break;
		default:
			$orderby = "order by ktghely asc, statusz asc";
		break;
	}
	
}

$q = "select ktghely, ktghelynev, case when aktivktghely then 'aktív' else 'zárolt' end as statusz ";
$q .= "from koltseghely $orderby;";



$fejlec ='Költséghelyek listája';


htmlHeader();
btnBackTopSticky();

$res = $pg->query($q);
echo"
<table class='table table-bordered table-stripped'>
  <thead class='text-center'>
	<tr class='bg-secondary'> 
		<th scope='col' colspan='6' class='text-center text-white'>$fejlec</th>
	</tr>
    <tr>
		<th scope='col'>
			<a href='index.php?o=ka'><button class='btn btn-secondary'><sup>A</sup>&dArr;<sub>Z</sub></button></a>
			Költséghely
			<a href='index.php?o=kd'><button class='btn btn-secondary'><sup>Z</sup>&uArr;<sub>A</sub></button></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=na'><button class='btn btn-secondary'><sup>A</sup>&dArr;<sub>Z</sub></button></a>
			Költséghely neve
			<a href='index.php?o=nd'><button class='btn btn-secondary'><sup>Z</sup>&uArr;<sub>A</sub></button></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=sa'><button class='btn btn-secondary'><sup>A</sup>&dArr;<sub>Z</sub></button></a>
			Státusz
			<a href='index.php?o=sd'><button class='btn btn-secondary'><sup>Z</sup>&uArr;<sub>A</sub></button></a>
		</th>
    </tr>
  </thead>
  <tbody>
";
while($row = $res->fetch(PDO::FETCH_ASSOC)) {
echo"
	<tr>
      <td class='text-center'>$row[ktghely]</td>
      <td>$row[ktghelynev]</td>
      <td class='text-center'>$row[statusz]</td>
";
}
echo "
	</tbody>
</table>
";

htmlFooter()
?>
