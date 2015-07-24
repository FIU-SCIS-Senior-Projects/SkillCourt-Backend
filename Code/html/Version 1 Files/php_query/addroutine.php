<?php
	$hostname_localhost ="localhost";
	$database_localhost ="skillcourt";
	$username_localhost ="skillcourt";
	$password_localhost ="skillcourt";
	$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost);
	or
	trigger_error(mysql_error(),E_USER_ERROR);

	mysql_select_db($database_localhost, $localhost);

	$routinename = testforced //$_POST['rName'];
	$routinedescription = this is a forced test //$_POST['rDesc'];
	$routineID = 33 // mysql_query("SELECT COUNT(*) FROM Routine)") + 1;

	$query_add = "INSERT INTO 'skillcourt'.'Routine' ('rname', 'rid', 'descr')  VALUES ('forcedtest', '4124', 'This is a very forced test')";//('".$routinename."', '".$routineID."', '".$routinedescription"')";
	mysql_query($query_add) or die(mysql_error());

	echo "Added " + $routinename + " as ID " + routineID;

	mysql_close();
?>
