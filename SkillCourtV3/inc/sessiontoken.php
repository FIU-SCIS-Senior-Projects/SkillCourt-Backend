<?php 
	include_once 'parseHeader.php';

	use Parse\ParseUser;
	use Parse\ParseObject;
	use Parse\ParseException;
	
	$sessionToken = ParseUser::getCurrentUser()->getSessionToken();
	$trimmedSession = trim($sessionToken);
	echo $trimmedSession;
?>