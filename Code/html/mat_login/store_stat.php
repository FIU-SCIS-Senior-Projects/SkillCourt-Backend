<?php
//chgjbkk
$hostname_localhost = "localhost";
$database_localhost = "skillcourt";
$username_localhost = "skillcourt";
$password_localhost = "skillcourt";
$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
or
trigger_error(mysql_error(),E_USER_ERROR);

mysql_select_db($database_localhost,$localhost);
$user = $_POST['username'];
$level = $_POST['level'];
$date = $_POST['date'];
$points = $_POST['points'];
$shots = $_POST['shots'];
$streak = $_POST['streak'];
$tbs = $_POST['tbs'];
$tbsot = $_POST['tbsot'];
$force = $_POST['force'];
$rounds = $_POST['rounds'];

$query_search = "INSERT INTO statistic (puname, level, dateTime, points, streak, timeBtwShots, timeBetwShotsOnTarget, numShots, frce, numRounds) VALUES ('" . $user . "', '" . $level . ", " . $date . "','" . $points . "','" . $streak . "','" . $tbs . "','" . $tbsot . "','" . $shots . "','" . $force . "','" . $rounds . "')";
 
$query_exec = mysql_query($query_search) or die(mysql_error());
$data = mysql_fetch_assoc($query_exec);

echo "inserted";
?>
