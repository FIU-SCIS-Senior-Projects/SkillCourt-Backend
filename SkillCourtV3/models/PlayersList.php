<?php 

include_once './inc/parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;
use Parse\ParseQuery;

class PlayersList
{

	public function signPlayer($id)
	{
		$currentUser = ParseUser::getCurrentUser();
		$username = $this->getUserById($id);

		$newSignedPlayer = new ParseObject("SignedPlayer");
        $newSignedPlayer->set("player",$username->getObjectId);
        $newSignedPlayer->set("coach",$currentUser);
        $newSignedPlayer->set("playerUsername",$username[0]->get("username"));
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

	public function getUserById($id)
	{
		$query = ParseUser::query();
		try {
		  $leUser = $query->get($id);
		  // The object was retrieved successfully.
		} catch (ParseException $ex) {
		  // The object was not retrieved successfully.
		  // error is a ParseException with an error code and message.
		}

		$username = $leUser->get('username');
		return $username;
	}

	public function searchPlayer($filter, $q)
	{
		$query = ParseUser::query();
		$results;
		//Get all the users that are not coaches
		switch ($filter) {
			case 'firstname':
				$query->equalTo("firstName", $q);
				$results = $query->find();
				break;
			case 'lastname':
				$query->equalTo("lastName", $q);
				$results = $query->find();
				break;
			case 'username':
				$query->equalTo("username", $q);
				$results = $query->find();
				break;
			case 'position':
				$query->equalTo("position", $q);
				$results = $query->find();
				break;
			case 'email':
				$query->equalTo("email", $q);
				$results = $query->find();
				break;
			default:
				//Query for all users whom are not coaches
				$query->notEqualTo("position", $q);
				$results = $query->find();
				break;
		}
		return $results;
	}

	public function getSignedPlayers()
	{
		//All players
		$allPlayers = $this->searchPlayer('default', 'coach');

		//Signed Players
		$allSignedPlayers = $this->getPlayersSigned();

		//Get the User Objects to be returned
		$results = $this->getUserObject($allPlayers, $allSignedPlayers);
		return $results;
	}

	public function getSignedPlayersByCoach()
	{
		//Results contains all the players signed by this coach
		//Lets now return the object from the User class
		$myPlayers = $this->getPlayersSignedByCoach();
		$allPlayers = $this->searchPlayer('default', 'coach');

		$results = $this->getUserObject($allPlayers, $myPlayers);

		return $results;
	}

	public function getCoachName($signedPlayer)
	{
		$query = new ParseQuery('SignedPlayer');
		$query->equalTo('playerUsername', $signedPlayer);
		$player = $query->first();

		if(empty($player)){
			return "No Coach*";
		}else{
			return $player->get('coachUsername');
		}
	}

	public function getCurrentUser()
	{
		return ParseUser::getCurrentUser();
	}

	private function getPlayersSigned()
	{
		$query = new ParseQuery('SignedPlayer');
		$player = $query->find();
		return $player;
	}

	private function getPlayersSignedByCoach()
	{
		//Get the current user - Return this current user's players signed. 
		$currentUser = $this->getCurrentUser();
		$results;
		if ($currentUser) {
		    //do stuff with the user
			$query = new ParseQuery("SignedPlayer");
            $query->equalTo("coach",$currentUser);
            $results = $query->find();
		} else {
		    //This is an error... Deal with this later. 
		    $results = "ERROR";
		}
		return $results;
	}

	private function getUserObject($allPlayers, $signedPlayers)
	{
		$results = array();
		for ($i=0; $i < count($signedPlayers); $i++) { 
			//Lets loop through all the available players
			$username = $signedPlayers[$i]->get('playerUsername');
			foreach ($allPlayers as $player) {
				//Get the player's username
				$allPlayerUsername = $player->get('username');
				
				//If this two are equal, then get that User object
				if(strcasecmp($username, $allPlayerUsername) == 0)
				{
					//If true, then we push this player onto our results array
					array_push($results, $player);
				}
			}
		}
		return $results;
	}
}

?>