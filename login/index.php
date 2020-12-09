<?php
/*
 * Bejelentkezés űrlapja
 * 
 */

require_once '../inc/func.php';

if(isset($_SESSION['kalib_fhnev']) && $_SESSION['kalib_fhnev'] !='') {
	header("Location: /kalibra/logout/index.php");
}

htmlHeader();

echo "
<div class='contener-fluid'>
	<div id='login-form'>
		<h2 class='text-center'>Bejelentkezés</h2>
		<form method='post' action='login.php'>
			<div class='form-group'>
				<input type='text' class='form-control' id='fhnev' name='fhnev'
					placeholder='Felhasználónév' autocomplete='off' maxlength='25'
					required autofocus>
			</div>
			<div class='form-group'>
				<input type='password' class='form-control' id='jelszo' name='jelszo'
					placeholder='Jelszó' autocomplete='off' maxlength='25'
					required autofocus>
			</div>
			<div class='form-group text-center'>
				<input type='submit' class='btn' name='login' value='Bejelentkezés'>&nbsp;
			</div>
		</form>
	</div>
</div>";

htmlFooter();
?>
