<?php
/*
 * Hibás bejelentkezés
 */
require_once '../inc/func.php';


htmlHeader();

echo "
<div class='contener-fluid alert alert-danger text-center'>
	<h4 class='alert-heading'>A rendszer használatához be kell jelentkezni,<br> de a bejelentkezés nem sikerült!</h4>
	<p>
		<a href='/kalibra/index.php'><button class='btn btn-danger'>Ismét</button></a>
	</p>
</div>";

htmlFooter();
