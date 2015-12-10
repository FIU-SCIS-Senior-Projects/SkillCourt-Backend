<?php
$hostname_localhost = "localhost";
$database_localhost = "skillcourt";
$username_localhost = "skillcourt";
$password_localhost = "skillcourt";
$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
or
trigger_error(mysql_error(),E_USER_ERROR);

mysql_select_db($database_localhost,$localhost);

$email = $_POST['email'];

$query_search = "SELECT * FROM player WHERE email = '".$email."'";
$query_exec = mysql_query($query_search) or die(mysql_error());
$data = mysql_fetch_assoc($query_exec);

echo $data['puname']." ".$data['pw'];
?>
