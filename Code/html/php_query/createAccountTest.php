<?php
$hostname_localhost ="localhost";
$database_localhost ="skillcourt";
$username_localhost ="skillcourt";
$password_localhost ="skillcourt";
$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
or
trigger_error(mysql_error(),E_USER_ERROR);

mysql_select_db($database_localhost, $localhost);


$query_search = "insert into player values('AAAAAA', 'AAAA', 'AAAAA', 'AAAA', 'AAAAA', '1980-03-25', 'AAAA@skilcourt.com', 'mid')";
$query_exec = mysql_query($query_search) or die(mysql_error());
$rows = mysql_num_rows($query_exec);
//echo $rows;
 if($rows == 0) { 
 echo "No Such User Found"; 
 }
 else  {
	echo "User Found"; 
}
?>

