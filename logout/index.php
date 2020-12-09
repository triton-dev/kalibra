<?php

require_once '../inc/func.php';

htmlHeader();

echo "
<div class='contener-fluid alert alert-danger'>
	<div id='logout-form'>
		<h2 class='text-center'>Kijelentkezés</h2>
		<form method='post' action='logout.php'>
			<div class='form-group text-center'>
				<input type='submit' class='btn btn-danger' name='logout' value='Kijelentkezés'>&nbsp;
				<input type='submit' class='btn btn-info' name='cancel' value='Mégsem'>
			</div>
		</form>
	</div>
</div>";

htmlFooter();
?>

