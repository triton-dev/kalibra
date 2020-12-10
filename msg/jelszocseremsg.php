<?php
/*
 * Jelszócsere üzenetei
 */
require_once '../inc/func.php';

htmlHeader();

if(isset($_GET['m'])) {
	switch ($_GET['m']){
// Sikerült
		case 't':
		echo "
			<div class='contener-fluid alert alert-success text-center' >
				<h2 class='text-center' >Sikeres jelszócsere</h2>
				<a href='/kalibra/index.php'><button class='btn btn-success'>Vissza</button></a>
			</div>";
		break;
// Nem sikerült
		case f:
		default:
		echo "
			<div class='contener-fluid alert alert-danger text-center'>
				<h4 class='alert-heading'>A jelszó megváltoztatása nem sikerült!</h4>
				<p>
					<a href='/kalibra/index.php'><button class='btn btn-danger'>Vissza</button></a>
				</p>
			</div>";
		
	}	
}

htmlFooter();
?>
