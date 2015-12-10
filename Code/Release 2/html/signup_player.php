<?php
    
    include_once 'parseHeader.php';
    
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    use Parse\ParseQuery;
    
    $currentUser = ParseUser::getCurrentUser();
    
    if (isset($_POST['usernamePlayersPage'])) {
        
        $username = $_POST['usernamePlayersPage'];
        
        $query = ParseUser::query();
        $query->equalTo("username", $username);
        $usernameExists = $query->find();
        if (count($usernameExists)) {
            $query = new ParseQuery("SignedPlayer");
            $query->equalTo("playerUsername",$username);
            $signedPlayerExists = $query->find();
            // If username exists in the system and it does not have a coach assigned
            if (count($signedPlayerExists) == 0) {
                //echo "Username is available for addition";
                $newSignedPlayer = new ParseObject("SignedPlayer");
                $newSignedPlayer->set("player",$usernameExists[0]);
                $newSignedPlayer->set("coach",$currentUser);
                $newSignedPlayer->set("playerUsername",$usernameExists[0]->get("username"));
                $newSignedPlayer->set("coachUsername",$currentUser->get("username"));
                try {
                    $newSignedPlayer->save();
					if(isset($_SESSION["myPlayers"])) array_push($_SESSION["myPlayers"] , $usernameExists);
					
                    header('Location:managePlayers.php?sc');
                    echo 'New object created with objectId: ' . $newSignedPlayer->getObjectId();
                } catch (ParseException $ex) {
                    // Execute any logic that should take place if the save fails.
                    // error is a ParseException object with an error code and message.
                    echo 'Failed to create new object, with error message: ' . $ex->getMessage();
                }
            } else {
                header('Location:managePlayers.php?error');
                echo "Username already has a coach assigned" ;
            }
        } else {
            header('Location:managePlayers.php?error');
            echo "Username doesn't exist";
        }
        
    } else {
        // The correct POST variables were not sent to this page.
        //echo 'Invalid Request';
        header('Location:managePlayers.php?error=1');
    }
    
?>
