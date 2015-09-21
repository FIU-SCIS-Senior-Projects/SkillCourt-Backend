<?php
//This could potentially be a controller

include_once 'parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;

if (isset($_POST['username'], $_POST['password'])) {

    $username = $_POST['username']; 
    $password = $_POST['password'];
    
    try {
  		$user = ParseUser::logIn($username, $password);
  		$currentUser = ParseUser::getCurrentUser();
		echo $currentUser->getUsername();
		header('Location: ../html/main.php');
  		// Do stuff after successful login.
	} catch (ParseException $error) {
  		// The login failed. Check error to see why.
  		echo $error->getCode() . " " . $error->getMessage();
  		header('Location: index.php?error=1');
	}
	
	
} else {
    // The correct POST variables were not sent to this page.
    echo 'Invalid Request';
}

?>
