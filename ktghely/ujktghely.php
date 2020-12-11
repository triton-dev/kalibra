<?php
/*
 * Új költség létrehozás űrlapja
 */
require_once '../inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_SESSION['kalib_alapjelszo']) && $_SESSION['kalib_alapjelszo'] === true) {
	header("Location: /kalibra/jelszocsere/index.php");
}

htmlHeader();
?>
<script>
	function showHint(str) {
		if (str.length == 0) {
			document.getElementById("ajaxHint").innerHTML = "";
			return;
		} else {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.onreadystatechange = function() {
				if (this.readyState == 4 && this.status == 200) {
					document.getElementById("ajaxHint").innerHTML = this.responseText;
				}
			};
			xmlhttp.open("GET", "gethint.php?q=" + str, true);
			xmlhttp.send();
		}
	}
</script>

<?php

echo "
<div class='contener-fluid'>
	<div id='login-form'>
		<h2 class='text-center'>Új költséghely</h2>
		<form method='post' action='ujktghely.php'>
			<div class='form-group'>
				<input type='text'
					class='form-control' 
					id='ktghely' 
					name='ktghely'
					placeholder='99-999-9' 
					autocomplete='off' 
					maxlength='8'
					required autofocus pattern='[0-9]{2}-[0-9]{3}-[0-9]{1}$'
					onkeyup='showHint(this.value)'
					>
				<span id='ajaxHint'>&nbsp;</span>
			</div>
			<div class='form-group'>
				<input type='text' 
					class='form-control' 
					id='ktghelynev' 
					name='ktghelynev'
					placeholder='Költséghely neve' 
					autocomplete='off' 
					maxlength='40'
					required 
					autofocus
				>
			</div>
			<div class='form-group'>
				<input type='submit' class='btn' name='login' value='Bejelentkezés'>
			</div>			
		</form>
	</div>
</div>";

htmlFooter();
