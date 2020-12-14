<?php
/*
 * Új költséghely
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
function segit(str) {
	if(str.length == 0) {
		document.getElementBy("sugo").innerHtml = "";
		return;
	}
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            document.getElementById("sugo").innerHTML = this.responseText;
       }
    };
    xhttp.open("GET", "ajax_info.php?q=" + str, true);
    xhttp.send()
	
}
</script>


<?php
echo "
<div class='contener-fluid'>
	<div id='login-form'>
		<form method='post' action=''>
		<div class='form-group'>
			<input type='text'
				class='form-control'
				name='ktghely'
				autocomplete=off
				maxlength=8
				required
				autofocus
				pattern='[0-9]{2}-[0-9]{3}-[0-9]{1}'
				placeholder='88-888-8'
				onkeyup='segit(this.value)'
			>
			<p class='small text-muted'><span id='sugo' class='text-sm'></span></p>
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
		<div class='form-group text-center'>
			<input type='submit'
				class='btn btn-success'
				name='submit'
				value='Mentés'
			>
		</div>
		</form>
		<p class='text-center'>
			<a href='/kalibra/index.php'>
				<button class='btn btn-danger'>Mégsem</button>
			</a>
		</p>
	</div>
</div>
";

htmlFooter();
?>

