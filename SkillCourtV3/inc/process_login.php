<?php 
  include_once 'parseHeader.php';

  use Parse\ParseUser;
  use Parse\ParseObject;
  use Parse\ParseException;
  
  if(isset($_POST['action'])) {
    if($_POST['action'] == "login")
    {
      /**
      * we can pass any action like block, follow, unfollow, send PM....
      * if we get a 'follow' action then we could take the user ID and create a SQL command
      * but with no database, we can simply assume the follow action has been completed and return 'ok'
      **/
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