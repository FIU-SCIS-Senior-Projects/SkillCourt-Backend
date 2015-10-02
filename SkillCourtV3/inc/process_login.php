<?php
//This could potentially be a controller

include_once 'parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;

if (isset($_POST['username'], $_POST['password'])) {

    $logusername = $_POST['username']; 
    $logpassword = $_POST['password'];
    
    try {
  		$user = ParseUser::logIn($logusername, $logpassword);
		  header('Location: ../index.php');
  		// Do stuff after successful login.
      try{
        $curUser->save();
      }catch(ParseException $ex){
        // Execute any logic that should take place if the save fails.
        // error is a ParseException object with an error code and message.
        echo 'Failed to create new object, with error message: ' . $ex->getMessage();
      }

	} catch (ParseException $error) {
  		// The login failed. Check error to see why.
  		echo $error->getCode() . " " . $error->getMessage();
      //Here tell the user the login has failed. due to a invalid email or password
  		header('Location: ../index.php?error=1');
	}
	
	
} else {
    // The correct POST variables were not sent to this page.
    echo 'Invalid Request';
}

?>