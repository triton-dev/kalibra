<?php
/*
 * Dolgozók listáj menü feldolgozása
 */
require_once '../inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_SESSION['kalib_alapjelszo']) && $_SESSION['kalib_alapjelszo'] === true) {
	header("Location: /kalibra/jelszocsere/index.php");
}

if(!isset($_GET['m'])) {
	header("Location: /kalibra/index.php");
}

$q = '';
$fejlec ='';

switch($_GET['m']) {
	
	case 'a':
		$q = "table v_aktivdolgozo;";
		$fejlec = "Aktív dolgozók";
	break;
	case 'p':
		$q = "table v_passzivdolgozo;";
		$fejlec = "Nem aktív dolgozók";
	break;
	case 'm':
		$q = "table v_dolgozo;";
		$fejlec = "Minden dolgozó";
	break;
	case 'n':
	
	break;
	default:
		header("Location: /kalibra/index.php");
	break;
}

htmlHeader();
btnBackTopSticky();

$res = $pg->query($q);
echo"
<table class='table table-bordered table-stripped'>
  <thead class='text-center'>
	<tr class='bg-secondary'> 
		<th scope='col' colspan='6' class='text-center text-white'>$fejlec</th>
	</tr>
    <tr>
      <th scope='col'>Törzsszám</th>
      <th scope='col'>Tit.</th>
      <th scope='col'>Teljes név</th>
      <th scope='col'>Költséghely</th>
      <th scope='col'>Költséghely neve</th>
      <th scope='col'>Státusz</th>
    </tr>
  </thead>
  <tbody>
";
while($row = $res->fetch(PDO::FETCH_ASSOC)) {
echo"
	<tr>
      <td class='text-center'>$row[torzsszam]</td>
      <td class='text-right'>$row[titulus]</td>
      <td>$row[nev]</td>
      <td>$row[ktghely]</td>
      <td>$row[ktghelynev]</td>
      <td>$row[statusz]</td>
    </tr>
";
}
echo "
	</tbody>
</table>
";

htmlFooter()
?>
