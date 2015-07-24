<?php

$hostname_localhost ="localhost";
$database_localhost ="skillcourt";
$username_localhost ="skillcourt";
$password_localhost ="skillcourt";
$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
or
trigger_error(mysql_error(),E_USER_ERROR);

mysql_select_db($database_localhost, $localhost);

$puname = $_POST['puname'];


$query_search = "select * from statistic where puname = '".$puname."'";
$result = mysql_query($query_search);

$outp = "";

while($row = mysql_fetch_row($result))
{
	$outp = $outp.$row[0]." ".$row[1]." ".$row[2]." ".$row[3]." ".$row[4]." ".$row[5]." ".$row[6]." ".$row[7]." ".$row[8]."\n";
}


echo $outp;

?>

