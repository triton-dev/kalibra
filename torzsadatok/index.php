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
$q = "select cikkszam,megnevezes,gyarto,tipus,mukodes,eszkoztipus, ";
$q.= "osztas||' '|| osztasme _osztas, pontossag||' '|| pontossagme _pontossag, ";
$q.= "tartomany||' '||tartomanyme _tartomany,kalibciklus, ";
$q.= "case when zarolt then 'zárolt cikk' else 'aktív cikk' end as statusz ";
$q.= "from torzsadat $orderby;";

$fejlec ='Törzsadatok (cikktörzs)';


htmlHeader();
btnBackTopSticky();

$res = $pg->query($q);
echo"
<table class='table table-bordered table-stripped table-sm'>
  <thead class='text-center'>
	<tr class='bg-secondary'> 
		<th scope='col' colspan='6' class='text-center text-white'>$fejlec</th>
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
    </tr>
  </thead>
  <tbody>
";

while($row = $res->fetch(PDO::FETCH_ASSOC)) {
echo"
	<tr>
		<td class='text-center'>
			<button type='button' class='btn btn-primary' data-toggle='modal' data-target='#$row[cikkszam]'>
				$row[cikkszam]
			</button>
		</td>
		<td>$row[megnevezes]</td>
		<td>$row[gyarto]</td>
		<td>$row[tipus]</td>
		<td>$row[mukodes]</td>
		<td>$row[eszkoztipus]</td>
		
		<div class='modal fade' id='$row[cikkszam]' tabindex='-1' role='dialog' aria-labelledby='exampleModalLabel' aria-hidden='true'>
		  <div class='modal-dialog' role='document'>
			<div class='modal-content'>
			  <div class='modal-header'>
				<p class='text-center'></p><br>
				<h5 class='modal-title' id='exampleModalLabel'>
					<img src='/kalibra/icon/info-circle.svg' height=32><br>
					$row[cikkszam]<br>
					$row[megnevezes]
				</h5>
				<button type='button' class='close' data-dismiss='modal' aria-label='Close'>
				  <span aria-hidden='true'>&times;</span>
				</button>
			  </div>
			  <div class='modal-body'>
				<p>Osztás: $row[_osztas]</p>
				<p>Pontosság: $row[_pontossag]</p>
				<p>Tartomány: $row[_tartomany]</p>
				<p>Kalibrálási ciklus: $row[kalibciklus]</p>
				<p>Státusz: $row[statusz]</p>
			  </div>
			  <div class='modal-footer'>
				<button type='button' class='btn btn-secondary' data-dismiss='modal'>Bezár</button>
			  </div>
			</div>
		  </div>
		</div>
	</tr>
		";
}
echo "
	</tbody>
</table>
";

htmlFooter()
?>

