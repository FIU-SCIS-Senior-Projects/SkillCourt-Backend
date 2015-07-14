<?php

require 'vendor/autoload.php';
 
use Parse\ParseClient;
 
ParseClient::initialize('pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF', '5ypPgG2h9m7qm78rANzsKa5eQS7MJSZcoLA5OvZr', 'fMAAA9m2Y7CV7OynAePqsqsKXjocgcSHIT0qoVE4');

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;

if (isset($_POST['username'], $_POST['password'])) {

    $username = $_POST['username']; // Player's username
    $password = $_POST['password']; // The non-hashed password.
    
    
    try {
  		$user = ParseUser::logIn($username, $password);
  		echo "success";
  		// Do stuff after successful login.
	} catch (ParseException $error) {
  		// The login failed. Check error to see why.
  		echo $error->getMessage();
	}
    
    /*
    if (login($username, $password, $userType, $mysqli) == true) {
        // Login success
        header('Location: ../Main.php');
    } else {
        // Login failed
        header('Location: ../index.php?error=1');
    }*/
    
} else {
    // The correct POST variables were not sent to this page.
    echo 'Invalid Request';
}
