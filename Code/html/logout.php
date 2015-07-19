<?php
	include_once("parseHeader.php");
	
	use Parse\ParseUser;
	use Parse\ParseObject;
	use Parse\ParseException;
	
	ParseUser::logOut();
	session_unset();
	Header('Location: index.php');
?>