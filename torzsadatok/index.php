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
$orderby = "order by cikkszam asc statusz asc";

if(isset($_GET['o'])) {
	switch($_GET['o']) {
		case 'ca':
			$orderby = "order by cikkszam asc, statusz asc";
		break;
		case 'cd':
			$orderby = "order by cikkszam desc, statusz asc";
		break;
		case 'na':
			$orderby = "order by megnevezes asc, statusz asc";
		break;
		case 'nd':
			$orderby = "order by megnevezes desc, statusz asc";
		break;
		case 'da':
			$orderby = "order by gyarto asc, statusz asc";
		break;
		case 'dd':
			$orderby = "order by gyarto desc, statusz asc";
		break;
		case 'ta':
			$orderby = "order by tipus asc, statusz asc";
		break;
		case 'td':
			$orderby = "order by tipus desc, statusz asc";
		break;
		case 'ma':
			$orderby = "order by mukodes asc, statusz asc";
		break;
		case 'md':
			$orderby = "order by mukodes desc, statusz asc";
		break;
		case 'ea':
			$orderby = "order by eszkoztipus asc, statusz asc";
		break;
		case 'ed':
			$orderby = "order by eszkoztipus desc, statusz asc";
		break;	
		default:
			$orderby = "order by cikkszam asc, statusz asc";
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
<table class='table table-bordered table-stripped'>
  <thead class='text-center'>
	<tr class='bg-secondary'> 
		<th scope='col' colspan='6' class='text-center text-white'>$fejlec</th>
	</tr>
    <tr>
		<th scope='col'>
			<a href='index.php?o=ca'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Cikkszám
			<a href='index.php?o=cd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=na'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Megnevezés
			<a href='index.php?o=nd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=da'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Gyártó
			<a href='index.php?o=dd'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=ta'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Típus
			<a href='index.php?o=td'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=ma'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Működési mód
			<a href='index.php?o=md'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=ea'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Eszköz típus
			<a href='index.php?o=ed'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
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

