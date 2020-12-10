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
  <li class='nav-item dropdown'>
    <a class='nav-link dropdown-toggle' data-toggle='dropdown' href='#' role='button' aria-haspopup='true' aria-expanded='false'>Dolgozók</a>
    <div class='dropdown-menu'>
      <a class='dropdown-item' href='/kalibra/dolgozok/index.php?m=a'>Aktív dolgozók</a>
      <a class='dropdown-item' href='/kalibra/dolgozok/index.php?m=p'>Nem aktív dolgozók</a>
      <a class='dropdown-item' href='/kalibra/dolgozok/index.php?m=m'>Minden dolgozó</a>
      <div class='dropdown-divider'></div>
      <a class='dropdown-item' href='/kalibra/dolgozok/index.php?m=n'>Új dolgozó</a>
    </div>
  </li>
    <li class='nav-item dropdown'>
    <a class='nav-link dropdown-toggle' data-toggle='dropdown' href='#' role='button' aria-haspopup='true' aria-expanded='false'>Törzsadatok</a>
    <div class='dropdown-menu'>
      <a class='dropdown-item' href='/kalibra/#/'>Cikktörzs</a>
      <a class='dropdown-item' href='/kalibra/#/'>Új cikk</a>
      <div class='dropdown-divider'></div>
      <a class='dropdown-item' href='/kalibra/#/'>Költséghelyek</a>
      <a class='dropdown-item' href='/kalibra/#/'>Új Költséghely</a>
      <div class='dropdown-divider'></div>
      <a class='dropdown-item' href='/kalibra/#/'>Partnerek</a>
      <a class='dropdown-item' href='/kalibra/#/'>Új partner</a>
      <div class='dropdown-divider'></div>
      <a class='dropdown-item' href='/kalibra/#/'>Felhasználók</a>
      <a class='dropdown-item' href='/kalibra/#/'>Új felhasználó</a>
      <div class='dropdown-divider'></div>
      <a class='dropdown-item' href='/kalibra/#/'>Szerepek</a>
      <a class='dropdown-item' href='/kalibra/#/'>Új szerep</a>
      <div class='dropdown-divider'></div>
      <a class='dropdown-item' href='/kalibra/#/'>Minősítések</a>
      <a class='dropdown-item' href='/kalibra/#/'>Eszköztípusok</a>
      <a class='dropdown-item' href='/kalibra/#/'>Működési módok</a>
      <a class='dropdown-item' href='/kalibra/#/'>Mértékegységek</a>
    </div>
  </li>
  <li class='nav-item'>
    <a class='nav-link' href='#'>Link</a>
  </li>
</ul>
";

htmlFooter();
?>