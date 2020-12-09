<?php
/*
 * Jelszó cseréje.
 * Ha még alapértelmezett, nincs MÉGSEM gomb.
 */
require_once '../inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

htmlHeader();

echo "
<div class='contener-fluid'>
	<div id='login-form' class='text-center'>
		<h2 class='text-center'>Jelszó csere</h2>
		<form method='post' action='jelszocsere.php'>
			<div class='form-group'>
				<input type='password' class='form-control' id='regi' name='regi'
					placeholder='Régi jelszó' autocomplete='off' maxlength='25'
					required autofocus>
			</div>
			<div class='form-group'>
				<input type='password' class='form-control' id='jelszo1' name='jelszo1'
					placeholder='Új jelszó' autocomplete='off' maxlength='25'
					required autofocus>
			</div>
			<div class='form-group'>
				<input type='password' class='form-control' id='jelszo2' name='jelszo2'
					placeholder='Új jelszó ismét' autocomplete='off' maxlength='25'2
					required autofocus>
			</div>
			<div class='form-group text-center'>
				<input type='submit' class='btn btn-info' name='mentes' value='Mentés'>&nbsp;
			</div>
		</form>
";
if($_SESSION[''] == false) {
	echo "		<a href='/kalibra/index.php'><button class='btn btn-danger'>Mégsem</button></a>";
}
echo"
	</div>
</div>";


htmlFooter();
?>
