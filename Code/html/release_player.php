<?php
    
    include_once 'parseHeader.php';
    
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    use Parse\ParseQuery;
    
    $currentUser = ParseUser::getCurrentUser();
    
    if (isset($_POST["playerUsername"])) {
        $username = $_POST["playerUsername"];
        $query = new ParseQuery("SignedPlayer");
        $query->equalTo("playerUsername",$username);
        $results = $query->find();
        if (count($results) > 0) {
            $signedPlayerToDelete = $results[0];
            echo "Player " . $signedPlayerToDelete->get("playerUsername") . " Deleted";
            $signedPlayerToDelete->destroy();
        }
        //echo $username;
    } else {
        // The correct POST variables were not sent to this page.
        echo 'Invalid Request';
        //header('Location:managePlayers.php?error=1');
    }
    
    ?>
