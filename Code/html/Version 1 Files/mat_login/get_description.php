<?php
//get_description
$hostname_localhost = "localhost";
$database_localhost = "skillcourt";
$username_localhost = "skillcourt";
$password_localhost = "skillcourt";
$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
or
trigger_error(mysql_error(),E_USER_ERROR);

mysql_select_db($database_localhost,$localhost);

$query_search = "SELECT descr FROM routine WHERE rname ='" . $_POST['rname'] . "' and username='" . $_POST['uname'] . "' and usertype='" . $_POST['usertype'] . "'";
$query_exec = mysql_query($query_search) or die(mysql_error());
$data = mysql_fetch_assoc($query_exec);

echo $data['descr'];
?>
