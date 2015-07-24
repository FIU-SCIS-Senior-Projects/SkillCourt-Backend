<?php
$hostname_localhost = "localhost";
$database_localhost = "skillcourt";
$username_localhost = "skillcourt";
$password_localhost = "skillcourt";
$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
or
trigger_error(mysql_error(),E_USER_ERROR);

mysql_select_db($database_localhost,$localhost);

$routineName = $_POST['rname'];
$routineDescription = $_POST['descr'];
$routineID = mysql_query("SELECT COUNT(*) FROM Routine)")++;
$runQuery = mysql_query("INSERT INTO 'skillcourt'.'Routine' ('rname','rid','descr') VALUES ('".$routineName."', '".$routineID."', '".$descr."')";
echo "Inserted " .$routineName. " into database as ID " .$routineID.;

mysql.close();
?>
