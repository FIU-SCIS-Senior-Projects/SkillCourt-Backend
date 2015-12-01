<?php 

include_once 'parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;
use Parse\ParseQuery;

	// Here we will only retrieve values from the already saved data in the session variables
	//Check for Post variable to determine the next action to take
	if (isset($_POST['id']) && isset($_POST['type'])) {

	    $routineId = $_POST['id'];
	    $routineType = $_POST['type'];
	    getPlayers($routineId, $routineType);

	}else if(isset($_GET["assign"]))
	{
		// Get this coaches players - signed players and display them. 
		$myPlayers = getPlayersSignedByCoach();
		$allPlayers = searchPlayer('default', 'coach');

		$results = getUserObject($allPlayers, $myPlayers);
		$_SESSION['allPlayers'] = $results;

		for($p = 0 ; $p < count($results) ; $p++)
		{
			$playerObject = $results[$p];
			$playerUsername = $playerObject->get('username') ; 
			$playerId = $playerObject->getObjectId();
			echo '<option value="'.$playerId.'">' ;
			echo $playerUsername;
			echo '</option>';
		}
	}

	function getCurrUser()
	{
		return ParseUser::getCurrentUser();	
	}

	function getPlayersSignedByCoach()
	{
		//Get the current user - Return this current user's players signed. 
		$currentUser = getCurrUser();
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

	function searchPlayer($filter, $q)
	{
		$query = ParseUser::query();
		$results;
		$query->notEqualTo("position", $q);
		$results = $query->find();
		return $results;
	}

	function getUserObject($allPlayers, $signedPlayers)
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

	//This function will return the players alongside information about a routine
	function getPlayers($routineId, $routineType)
	{
		//Get the players for this routine
		$playersCustom = $_SESSION['playersCustom'];
		//Get all the default routines for this user
		$playersDefault = $_SESSION['playersDefault'];

		$routine = getRoutineObject($routineId, $routineType);

		if($routineType == 'custom'){
			$usersAssigned = $playersCustom[$routineId];

		}else if($routineType == 'default'){
			$usersAssigned = $playersDefault[$routineId];
		}

		//Here we echo what will be returned to the view
		echo '<select id="playerSelect" class="form-control">' ;
		foreach ($usersAssigned as $user) {
			echo '<option value="'. $user->getObjectId() .'">' ;
			echo $user->get("username") ;
			echo'</option>' ;
		}
		echo '</select>' ;
		echo '<label for="routineDescription" class="whiteHeaders" id="routineDescription">Routine Description: </label>';
		echo '<textarea class="form-control" id="description" readonly>'; 
		echo $routine->get("description") ;
		echo '</textarea>' ;
	}

	//Get users by ID - Not being used. 
	function getUserById($idsArray)
	{
		$query = ParseUser::query();
		$usersByRoutine = array();
		foreach ($idsArray as $object) {
			$query->get($object->getObjectId());
			$result = $query->find();
			array_push($usersByRoutine, $result[0]);
		}
		return $usersByRoutine;
	}

	/*
	*This functions will return routines given an ID. For custom and default routines
	*/
	function getRoutineObject($routineId, $routineType)
	{	
		// This will return the routine selected's information
		$routineObject = getRoutinesById($routineId, $routineType);
		return $routineObject[0];
	}

	function getRoutinesById($id, $type)
	{
		$returnRoutines;
		if($type == 'default'){
			$returnRoutines = queryRoutines($id, 'DefaultRoutine');
		}else if($type == 'custom'){
			$returnRoutines = queryRoutines($id, 'CustomRoutine');
		}
		return $returnRoutines;
	}

	function queryRoutines($id, $type)
	{
		$query = new ParseQuery($type);
		$query->get($id);
		return $query->find();
	}

	//Not being used. 
	function getAssignedPlayers($routinesObject, $type)
	{
		$fetch;
		if($type == 'default'){
			$query = new ParseQuery('AssignedRoutines');
			$query->equalTo('defaultRoutine',$routinesObject);
			$fetch = $query->find();
		}else if($type == 'custom'){
			$query = new ParseQuery('AssignedRoutines');
			$query->equalTo('customRoutine',$routinesObject);
			$fetch = $query->find();
		}
		return $fetch;
	}

 ?>