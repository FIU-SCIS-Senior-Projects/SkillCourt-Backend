<?php 
  include_once 'parseHeader.php';

  use Parse\ParseUser;
  use Parse\ParseObject;
  use Parse\ParseException;
  
  if(isset($_POST['action'])) {
    if($_POST['action'] == "login")
    {
      $sessionToken = $_POST['token'];
      try {
        $user = ParseUser::become($sessionToken);
        echo "become worked!";
          // The current user is now set to user.
      } catch (ParseException $ex) {
        // The token could not be validated.
        echo "become DID NOT worked";
      }
    }
    else if($_POST['action'] == "logout")
    {
      //Logout the user from the server
      session_unset(); 
      ParseUser::logout();
      echo "User has logged out";
    }
  }
?>