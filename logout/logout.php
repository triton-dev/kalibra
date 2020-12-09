<?php

require_once '../inc/func.php';

if(isset($_POST['cancel'])) {
	header("Location: /kalibra/index.php");
}

if(isset($_POST['logout'])) {
	session_destroy();
	header("Location: /kalibra/index.php");
}

?>
