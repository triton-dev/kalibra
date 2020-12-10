<?php
/*
 * Saját adatok módosítás ürlapja
 * 
 */

require_once '../inc/func.php';

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}


$q  = "select fhnev,vnev,knev,hnev,titulus,szerep from felhasznalo ";
$q .= "where fhnev='$_SESSION[kalib_fhnev]'; ";
$stmt = $pg->query($q);
$res = $stmt->fetch(PDO::FETCH_ASSOC);

htmlHeader();

echo "
<div class='contener-fluid'>
	<div id='sajatadat-form'>
		<h2 class='text-center'>Saját adatok módosítása</h2>
		<form method='post' action='modosit.php'>
			<div class='form-group row'>
				<label for='fhnev' class='col-sm-4 col-form-label'>Fehasználónév:</label>
				<div class='col-sm-8'>
				<input type='text' class='form-control' id='fhnev' name='fhnev'
					placeholder='Felhasználónév' autocomplete='off' maxlength='25'
					required autofocus readonly value='$res[fhnev]'>
				</div>
			</div>
			<div class='form-group row'>
				<label for='szerep' class='col-sm-4 col-form-label'>Szerep:</label>
				<div class='col-sm-8'>
				<input type='text' class='form-control' id='szerep' name='szerep'
					placeholder='Szerep' autocomplete='off' maxlength='25'
					required autofocus disabled value='$res[szerep]'>
				</div>
			</div>
			<div class='form-group row'>
				<label for='vnev' class='col-sm-4 col-form-label'>Vezetéknév:</label>
				<div class='col-sm-8'>
				<input type='text' class='form-control' id='vnev' name='vnev'
					placeholder='Vezetéknév' autocomplete='off' maxlength='25'
					required autofocus value='$res[vnev]'>
				</div>
			</div>
			<div class='form-group row'>
				<label for='knev' class='col-sm-4 col-form-label'>Keresztnév:</label>
				<div class='col-sm-8'>
				<input type='text' class='form-control' id='knev' name='knev'
					placeholder='Keresztnév' autocomplete='off' maxlength='25'
					required autofocus value='$res[knev]'>
				</div>
			</div>
			<div class='form-group row'>
				<label for='hnev' class='col-sm-4 col-form-label'>Harmadik név:</label>
				<div class='col-sm-8'>
				<input type='text' class='form-control' id='hnev' name='hnev'
					placeholder='Harmadik név' autocomplete='off' maxlength='25'
					autofocus value='$res[hnev]'>
				</div>
			</div>
			<div class='form-group text-center'>
				<input type='submit' class='btn btn-success' name='mentes' value='Mentés'>&nbsp;
				<input type='submit' class='btn btn-danger' name='cancel' value='Mégsem'>&nbsp;
			</div>
		</form>
	</div>
</div>";

htmlFooter();
?>
