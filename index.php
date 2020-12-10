<?php
/*
 * FŐLAP
 */
require_once 'inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_SESSION['kalib_alapjelszo']) && $_SESSION['kalib_alapjelszo'] === true) {
	header("Location: /kalibra/jelszocsere/index.php");
}

htmlHeader();

echo"
<ul class='nav nav-pills'>
  <li class='nav-item dropdown'>
    <a class='nav-link dropdown-toggle' data-toggle='dropdown' href='#' role='button' aria-haspopup='true' aria-expanded='false'>$_SESSION[kalib_fhnev]</a>
    <div class='dropdown-menu'>
      <a class='dropdown-item' href='/kalibra/sajatadatok/'>Saját adatok módosítása</a>
      <a class='dropdown-item' href='/kalibra/jelszocsere/'>Jelszó módosítása</a>
      <div class='dropdown-divider'></div>
      <a class='dropdown-item' href='logout/'>Kijelentkezés</a>
    </div>
  </li>
  <li class='nav-item'>
    <a class='nav-link' href='#'>Link</a>
  </li>
</ul>
";

htmlFooter();
?>
