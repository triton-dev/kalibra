<?php

session_start();

// pgConnect

$hostname = exec('hostname');

//fejlesztői környezet
$DEV = 'd10';

switch ($hostname) {
  case $DEV:
		$host = '127.0.0.1';
		$port = 5432;
		$db = 'kalibra';
		$username = 'gyuri';
		$password = 'qaysew';
		$dsn = "pgsql: host=$host;port=$port;dbname=$db;user=$username;password=$password";
        break;
  default:
		$host = '192.168.100.155';
		$port = 5432;
		$db = 'kalibra';
		$username = 'gyuri';
		$password = 'qaysew';
		$dsn = "pgsql: host=$host;port=$port;dbname=$db;user=$username;password=$password";
        break;
}

try {
        $pg = new PDO($dsn);
}

catch (PDOException $e){
        htmlHeader();
        echo "
        <div class='container'>
        <div class='alert alert-danger text-center'>
			Nem sikerült kapcsolódni az adatbázishoz.
        </div>
        </div>
        ";
        htmlFooter();
        die;
}

// end of pgConnect

function htmlHeader() {
echo "
<!doctype html>
<html lang='hu'>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<!-- Latest compiled and minified CSS -->
<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css'>
<!-- jQuery library -->
<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>
<!-- Popper JS -->
<script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js'></script>
<!-- Latest compiled JavaScript -->
<script src='https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js'></script>
<!-- Saját css betöltése -->
<link rel='stylesheet' href='/kalibra/css/custom-css.css?v=1'>
<link rel='shortcut icon' href='/kalibra/icon/kalibra.ico' type='image/x-icon'>
<link rel='icon' href='/kalibra/icon/kalibra.ico' type='image/x-icon'>
<title>Kalibra</title>
</head>
<body>
<header id='top'>
        <h1 style='background-color:yellow;color:navy;padding:1rem;margin-bottom:0px;' class='text-center'>
                BKV Vasúti Járműjavító Kft.
        </h1>
        <h2 class='text-center alert alert-success'>
                Mérőeszköz és kalibrálás nyilvántartó
        </h2>
</header>
<section>
";
}

function htmlFooter() {
echo "
</section>
<footer>
<p class='text-center alert alert-success' style='font-size:0.75rem'>
        <b>BKV Vasúti Járműjavító Kft. &ndash; Kalibra </b><br>
        &copy; 2020. szikoragy
</p>
</footer>
</body>
</html>
";
}

 

// Állandók
$YEAR = date("Y",time());
$MONTH = date("m",time());
$DAY = date("d",time());
$DATE = "$YEAR-$MONTH-$DAY";
//Üzenetek kíírásához
function msg($type,$msg,$url1='',$urltxt1='',$url2='',$urltxt2='',$url3='',$urltxt3='') {
        switch($type) {
                case 'ERROR': // Hibaüzenet
                        $msgtype="'alert alert-danger text-center'";
                        $btntype="'btn btn-danger'";
                        break;
                case 'SUCCESS': // Rendben
                        $msgtype="'alert alert-success text-center'";
                        $btntype="'btn btn-success'";
                        break;
                case 'ALERT': // Figyelmeztetés
                        $msgtype="'alert alert-warning text-center'";
                        $btntype="'btn btn-warning'";
                        break;
                case 'INFO': // Információ
                        $msgtype ="'alert alert-secondary text-center'";
                        $btntype="'btn btn-secondary'";
                        break;
                default: // Általános üzenet
                        $msgtype="'alert alert-light text-center' style='border:1px solid silver;border-radius:1rem;'";
                        $btntype="'btn btn-basic'";
                        break;
        }
        echo "
                <div class='container'>
                <div class=$msgtype>";
                echo $msg."<br>";
                if($url1 != '') {
                        echo "&nbsp;<a href='$url1'><button class=$btntype>$urltxt1</button></a>&nbsp;";
                }
                if($url2 != '') {
                        echo "<a href='$url2'><button class=$btntype>$urltxt2</button></a>&nbsp;";
                }
                if($url3 != '') {
                        echo "<a href='$url33'><button class=$btntype>$urltxt3</button></a>&nbsp;";
                }
         echo "
                </div>
                </div>";
}



// sql parancs kiírásához
function sql($sql,$m=0) {
        if($m==0) {
                echo "<div class='container'><div class='alert alert-warning'>SQL: <br>$sql</div></div>";
        }
        else {
                echo "
                        <div class='container'>
                                <p class='alert alert-warning'>SQL:<br>
                                        <kbd style='font-size:12px;word-wrap:break-word;padding:0.5em'>$sql</kbd>
                                </p>
                </div>
                ";
        }
}

// $_SESSION kiíratása
function session($m=0) {
        if($m==0) {
                echo "<p> _SESSION:<br>";
                print_r($_SESSION);
                echo "</p>";
        }
        else {
                echo "<p>_SESSION:<br><pre style='font-size:12px;'>";
                        print_r($_SESSION);
                echo "</pre></p>";
        }
}

// $_POST kiírása
function post($m=0) {
        if($m==0) {
                echo "<p> _POST:<br>";
                print_r($_POST);
                echo "</p>";
        }
        else {
                echo "<p>_POST:<br><pre style='font-size:12px;'>";
                        print_r($_POST);
                echo "</pre></p>";
        }
}

// $_GET kiírása
function get($m=0) {
        if($m==0) {
                echo "<p> _GET:<br>";
                print_r($_GET);
                echo "</p>";
        }
        else {
echo "<p>_GET:<br><pre style='font-size:12px;'>";
                        print_r($_GET);
                echo "</pre></p>";
        }
}

 

 

function btnBack() {
        echo "<p><a href='index.php'><button class='btn btn-primary'>Vissza</button></a></p>";
}

function btnBackTopSticky() {
        echo "<p style='margin:0.5rem auto;' class='text-center sticky'>
			<a href='/kalibra/index.php'><button class='btn btn-primary'>Vissza</button></a>
			<a href='#top'><button class='btn btn-info'>Fel</button></a>
		</p>";
}

function endOfPage() {
        vissza();
        html_footer();
        die;
       }    
       
    

?>

