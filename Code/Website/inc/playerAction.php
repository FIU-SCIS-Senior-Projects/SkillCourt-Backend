<?php 
include_once 'parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;
use Parse\ParseQuery;

	if (isset($_POST['action'])) {
	    $id = $_POST['action'];
	    executeAction($id);
	}

	function executeAction($id)
	{
		$currentUser = ParseUser::getCurrentUser();
		$username = getUserById($id);

		$signedPlayers = getSignedPlayers($username->get('username'));
		if(!count($signedPlayers)){
			//Sign Player
			signPlayer($username, $currentUser);
	    }
	    else{
	    	//Release Player
	    	releasePlayer($signedPlayers);
	    }
	}

	function signPlayer($username, $currentUser)
	{
		$newSignedPlayer = new ParseObject("SignedPlayer");
        $newSignedPlayer->set("player",$username);
        $newSignedPlayer->set("coach",$currentUser);
        $newSignedPlayer->set("playerUsername",$username->get("username"));
        $newSignedPlayer->set("coachUsername",$currentUser->get("username"));
        try {
            $newSignedPlayer->save();
            echo 'New object created with objectId: ' . $newSignedPlayer->getObjectId();
        } catch (ParseException $ex) {
            // Execute any logic that should take place if the save fails.
            // error is a ParseException object with an error code and message.
            echo 'Failed to create new object, with error message: ' . $ex->getMessage();
        }
	}

	function releasePlayer($signedPlayer)
	{
		$signedPlayer[0]->destroy();
	}

	function getUserById($id)
	{
		$query = ParseUser::query();
		try {
		  $leUser = $query->get($id);
		  // The object was retrieved successfully.
		} catch (ParseException $ex) {
		  // The object was not retrieved successfully.
		  // error is a ParseException with an error code and message.
		}
		return $leUser;
	}

	function getSignedPlayers($username)
	{
		$query = new ParseQuery("SignedPlayer");
        $query->equalTo("playerUsername",$username);
        $signedPlayerExists = $query->find();
        return $signedPlayerExists;
	}
 ?>