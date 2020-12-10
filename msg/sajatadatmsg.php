<?php
/*
 * Saját adatok változtatása üzenetek
 */
require_once '../inc/func.php';

htmlHeader();

if(isset($_GET['m'])) {
	switch ($_GET['m']){
// Sikerült
		case 1:
		echo "
			<div class='contener-fluid alert alert-success text-center' >
				<h2 class='text-center' >Sikeres adatváltoztatás.</h2>
				<a href='/kalibra/index.php'><button class='btn btn-success'>Vissza</button></a>
			</div>";
		break;
// Nem sikerült
		case 0:
		default:
		echo "
			<div class='contener-fluid alert alert-danger text-center'>
				<h4 class='alert-heading'>Az adatváltoztatás nem sikerült!</h4>
				<p>
					<a href='/kalibra/index.php'><button class='btn btn-danger'>Vissza</button></a>
				</p>
			</div>";
		
	}	
}

htmlFooter();
?>
