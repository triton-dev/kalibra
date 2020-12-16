<?php
/*
 * Törzsadatok (cikktörzs)
 */
require_once '../inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_SESSION['kalib_alapjelszo']) && $_SESSION['kalib_alapjelszo'] === true) {
	header("Location: /kalibra/jelszocsere/index.php");
}
$orderby = "order by 1";

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


$q = "select cikkszam,megnevezes,gyarto,tipus,mukodes,eszkoztipus,osztas, ";
$q .="osztasme, pontossag, pontossagme,tartomany,tartomanyme,kalibciklus, ";
$q .="case when zarolt then 'aktív cikk' else 'zárolt cikk' end as statusz ";
$q .= "from torzsadat $orderby;";



$fejlec ='Törzsadatok (cikktörzs)';


htmlHeader();
btnBackTopSticky();

$res = $pg->query($q);
echo"
<table class='table table-bordered table-stripped'>
  <thead class='text-center'>
	<tr class='bg-secondary'> 
		<th scope='col' colspan='3' class='text-center text-white'>$fejlec</th>
	</tr>
    <tr>
		<th scope='col'>
			<a href='index.php?o=ka'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Cikkszám
			<a href='index.php?o=kd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=na'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Megnevezés
			<a href='index.php?o=nd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Gyártó
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Típus
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Működési mód
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Eszköz típus
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Osztás
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Osztás me.
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Pontosság
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			GPontosság me.
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Mérési tartomány
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Mérési. tart. me.
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Kalibrálási ciklus
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
				<th scope='col'>
			<a href='index.php?o=sa'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Státusz
			<a href='index.php?o=sd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
    </tr>
  </thead>
  <tbody>
";


sql($q);

while($row = $res->fetch(PDO::FETCH_ASSOC)) {
echo"
	<tr>
		<td>$row[cikkszam]</td>
		<td>$row[megnevezes]</td>
		<td>$row[gyarto]</td>
		<td>$row[tipus]</td>
		<td>$row[mukodes]</td>
		<td>$row[eszkoztipus]</td>
		<td>$row[osztas]</td>
		<td>$row[osztasme]</td>
		<td>$row[pontossag]</td>
		<td>$row[pontossagme]</td>
		<td>$row[tartomany]</td>
		<td>$row[tartumanyme]</td>
		<td>$row[kalibciklus]</td>
		<td class='text-center'>$row[statusz]</td>
";
}
echo "
	</tbody>
</table>
";

htmlFooter()
?>
