<?php
echo "6";
	$hostname_localhost ="localhost";
	$database_localhost ="skillcourt";
	$username_localhost ="skillcourt";
	$password_localhost ="skillcourt";
	echo "5";
	$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
	or
	trigger_error(mysql_error(),E_USER_ERROR);
echo "4";
	mysql_select_db($database_localhost, $localhost);

	$puname = $_POST['username'];
	$level = $_POST['level'];
	$dateTime = $_POST['date'];
	$points = $_POST['points'];
	$streak = $_POST['streak'];
	$tbs = $_POST['tbs'];
	$numShots = $_POST['shots'];
	$force = $_POST['force'];
	$shotsOT = $_POST['shotsOT'];
	echo "1";
	$query_exec = "INSERT INTO `skillcourt`.`statistic` (`puname`, `level`, `dateTime`, `points`, `streak`, `timeBtwShots`, `numShots`, `frce`, `shotsOnTarget`) VALUES ('".$puname."', '".$level."', '".$dateTime."', '".$points."', '".$streak."', '".$tbs."', '".$numShots."', '".$force."', '".$shotsOT."')";
	echo "2";
	mysql_query($query_exec) or die(mysql_error());
	echo "3";

	mysql_close();
?>
