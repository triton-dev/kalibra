<?php
/*
 * Partnerek listája
 */
require_once '../inc/func.php';


$auth_user=array("mérőeszköz felügyelő","metrológus","laborvezető","lekérdező","admin");  

if(!isset($_SESSION['kalib_szerep'])){
	header("Location: /kalibra/login/index.php");
}

if(isset($_SESSION['kalib_alapjelszo']) && $_SESSION['kalib_alapjelszo'] === true) {
	header("Location: /kalibra/jelszocsere/index.php");
}


$q = "select partnerkod, partnernev, case when aktivpartner then 'aktív' else 'zárolt' end as statusz ";
$q .= "from partner order by partnernev;";



$fejlec ='Partnereklistája';


htmlHeader();
btnBackTopSticky();

$res = $pg->query($q);
echo"
<table class='table table-bordered table-striped w-75' style='margin:0 auto;'>
  <thead class='text-center'>
	<tr class='bg-secondary'> 
		<th scope='col' colspan='3' class='text-center text-white'>$fejlec</th>
	</tr>
    <tr>
		<th scope='col'>
			Partnerkód
		</th>
		<th scope='col'>
			Partnernév
		<th scope='col'>
			Státusz
		</th>
    </tr>
    </thead>
  <tbody>
";
while($row = $res->fetch(PDO::FETCH_ASSOC)) {
echo"
	<tr>
		<td class='text-center'>$row[partnerkod]</td>
		<td>$row[partnernev]</td>
		<td class='text-center'>$row[statusz]</td>
    </tr>
";
}
echo "
	</tbody>
</table>
";

htmlFooter()
?>
