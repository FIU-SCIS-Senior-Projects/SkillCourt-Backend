<?php
//list_routines.php
	$hostname_localhost = "localhost";
	$database_localhost = "skillcourt";
	$username_localhost = "skillcourt";
	$password_localhost = "skillcourt";
	$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
	or
	trigger_error(mysql_error(),E_USER_ERROR);
	mysql_select_db($database_localhost, $localhost);

	$query_search = "SELECT * FROM routine WHERE username='" . $_POST['puname'] . "' and usertype = '" . $_POST['usertype'] . "'";
	$query_exec = mysql_query($query_search) or die(mysql_error());

	while ($row = mysql_fetch_array($query_exec, MYSQL_ASSOC)) {
		echo $row['rname'].",";
	}
?>
