<?php
/*
 * A kért funkciót a felhasználó a szerepköre miatt nem használhatja
 */
require_once '../inc/func.php';

htmlHeader();

echo "
<div class='contener-fluid alert alert-danger text-center'>
	<h4 class='alert-heading'>A kért funkció használatára nem jogosult!</h4>
	<p>
		<a href='/kalibra/index.php'><button class='btn btn-danger'>Vissza</button></a>
	</p>
</div>";

htmlFooter();
?>

