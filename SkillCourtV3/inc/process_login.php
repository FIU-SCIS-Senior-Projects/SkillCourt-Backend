<?php
include_once 'parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;

if (isset($_POST['username'], $_POST['password'])) {

    $logusername = $_POST['username']; 
    $logpassword = $_POST['password'];
    
    try{
      $user = ParseUser::logIn($logusername, $logpassword);
      header('Location: ../index.php');
    } catch(ParseException $error){
      // Login failed
      echo $error->getCode() . " " . $error->getMessage();
      //Here tell the user the login has failed. due to a invalid email or password
      $errorMessage = "ERROR";
      header('Location: ../index.php?error=1');      
    }
	
} else {
    // The correct POST variables were not sent to this page.
    echo 'Invalid Request';
}

?>