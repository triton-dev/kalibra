<?php
/*
 * ÉLŐ Eszközök (mérőeszközök listája)
 */
require_once '../inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_SESSION['kalib_alapjelszo']) && $_SESSION['kalib_alapjelszo'] === true) {
	header("Location: /kalibra/jelszocsere/index.php");
}

if(!isset($_GET['y'])){
	$y='&y=e';
	$where=' where aktiveszkoz ';
	$fejlec = 'ÉLŐ mérőeszközök listája';
} else {
	switch ($_GET['y']) {
		case 'e':
			$y='&y=e';
			$where=' where aktiveszkoz ';
			$fejlec = 'ÉLŐ mérőeszközök listája';
		break;
		case 's':
			$y='&y=s';
			$where=' where not aktiveszkoz ';
			$fejlec = 'SELEJTEZETT mérőeszközök listája';
		break;
		case 'm':
			$y='&y=m';
			$where='';
			$fejlec = 'MINDEN mérőeszköz';
		break;
		default:
			$y='&y=e';
			$where=' where aktiveszkoz ';
			$fejlec = 'ÉLŐ mérőeszközök listája';
		break;
	}
}

$orderby = "order by gravirszam asc";

if(isset($_GET['o'])) {
	switch($_GET['o']) {
		case 'ga':
			$orderby = "order by gravirszam asc";
		break;
		case 'gd':
			$orderby = "order by gravirszam desc";
		break;
		case 'ca':
			$orderby = "order by cikkszam asc";
		break;
		case 'cd':
			$orderby = "order by cikkszam desc";
		break;
		case 'na':
			$orderby = "order by megnevezes asc, aktiveszkoz asc";
		break;
		case 'nd':
			$orderby = "order by megnevezes desc, aktiveszkoz asc";
		break;
		case 'da':
			$orderby = "order by gyarto asc, aktiveszkoz asc";
		break;
		case 'dd':
			$orderby = "order by gyarto desc, aktiveszkoz asc";
		break;
		case 'ta':
			$orderby = "order by tipus asc, aktiveszkoz asc";
		break;
		case 'td':
			$orderby = "order by tipus desc, aktiveszkoz asc";
		break;
		case 'sa':
			$orderby = "order by mukodes asc, aktiveszkoz asc";
		break;
		case 'sd':
			$orderby = "order by mukodes desc, aktiveszkoz asc";
		break;
		case 'ea':
			$orderby = "order by eszkoztipus asc, aktiveszkoz asc";
		break;
		case 'ed':
			$orderby = "order by eszkoztipus desc, aktiveszkoz asc";
		break;	
		default:
			$orderby = "order by gravirszam asc";
		break;
	}
	
}

$q = "select gravirszam,cikkszam,gyarto,tipus,gysz,megnevezes,mukodes,";
$q .="eszkoztipus,_osztas,_pontossag,_tartomany,kalibciklus,ekalibciklus,";
$q .="_eszkoz,_torzseszkoz,uzemdatum,minosites,kaliblejar,tarhely,";
$q .= "seljavdatum,seldatum,_torzsstatusz,_eszkozstatusz,zarolt,aktiveszkoz";
$q .= " from v_eszkozlista $orderby ;";



//sql($q);

htmlHeader();
btnBackTopSticky();

$res = $pg->query($q);
echo"
<table class='table table-bordered table-stripped'>
  <thead class='text-center'>
	<tr class='bg-secondary'> 
		<th scope='col' colspan='7' class='text-center text-white'>$fejlec</th>
	</tr>
    <tr>
		<th scope='col'>
			<a href='index.php?o=ga$y'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Gravírszám
			<a href='index.php?o=gd$y'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=ca$y'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Cikkszám
			<a href='index.php?o=cd$y'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=da$y'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Gyártó
			<a href='index.php?o=dd$y'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=ta$y'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Típus
			<a href='index.php?o=td$y'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=ma$y'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Megnevezés
			<a href='index.php?o=md$y'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=sa$y'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Működési mód
			<a href='index.php?o=sd$y'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
		<th scope='col'>
			<a href='index.php?o=ea$y'><img src='/kalibra/icon/sort-alpha-down.svg' height:1rem;></a>
			Eszköz típus
			<a href='index.php?o=ed$y'><img src='/kalibra/icon/sort-alpha-up-alt.svg' height:1rem;></a>
		</th>
    </tr>
  </thead>
  <tbody>
";

while($row = $res->fetch(PDO::FETCH_ASSOC)) {
echo"
	<tr>
		<td class='text-center'>
			<button type='button' class='btn btn-primary' data-toggle='modal' data-target='#$row[gravirszam]'>
				$row[gravirszam]
			</button>
		</td>
		<td>$row[cikkszam]</td>
		<td>$row[gyarto]</td>
		<td>$row[tipus]</td>
		<td>$row[megnevezes]</td>
		<td>$row[mukodes]</td>
		<td>$row[eszkoztipus]</td>
		
		<div class='modal fade' id='$row[gravirszam]' tabindex='-1' role='dialog' aria-labelledby='exampleModalLabel' aria-hidden='true'>
			<div class='modal-dialog modal-lg'>
				<div class='modal-content'>
					<div class='modal-header'>
						<h5 class='modal-title' id='exampleModalLabel'>
							<img src='/kalibra/icon/info-circle.svg' height=32><br>
							<b>Gravírszám:</b> $row[gravirszam]<br>
							<b>Cikkszám:</b> $row[cikkszam]<br>
							<b>Megnevezés:</b> $row[megnevezes]<br>
							<b>Gyári szám:</b> $row[gysz]
						</h5>
						<button type='button' class='close' data-dismiss='modal' aria-label='Close'>
							<span aria-hidden='true'>&times;</span>
						</button>
					</div>
					<div class='modal-body'>
						<p><b>Osztás:</b> $row[_osztas]</p>
						<p><b>Pontosság:</b> $row[_pontossag]</p>
						<p><b>Tartomány:</b> $row[_tartomany]</p>
						<p><b>Törzs kalib. ciklus:</b> $row[kalibciklus]</p>
						<p><b>Eszköz egyedi kalib. ciklusa:</b> $row[ekalibciklus]</p>
						<p><b>Eszközszám/alszám:</b> $row[_eszkoz]</p>
						<p><b>Eszközfajta:</b> $row[_torzseszkoz]</p>
						<p><b>Üzembe helyezés dátuma:</b> $row[uzemdatum]</p>
						<p><b>Minősítés:</b> $row[minosites]</p>
						<p><b>Kalib. érvényessége:</b> $row[kaliblejar]</p>
						<p><b>Tárhely:</b> $row[tarhely]</p>
						<p><b>Selejtezési javaslat:</b> $row[seljavdatum]</p>
						<p><b>Selejtezés dátuma:</b> $row[seldatum]</p>
						<p><b>Cikkszám státusza:</b> $row[_torzsstatusz]</p>
						<p><b>Eszköz státusza:</b> $row[_eszkozstatusz]</p>
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


?>


<?php
htmlFooter();
?>
