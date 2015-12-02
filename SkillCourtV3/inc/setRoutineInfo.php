<?php
include_once 'parseHeader.php';
use Parse\ParseObject;
use Parse\ParseUser;
use Parse\ParseQuery ;
use Parse\ParseException ;
$currentUser = ParseUser::getCurrentUser() ;

// $i = $_POST["i"] ;
// $routine ;
// if($i < count($_SESSION["coachRoutines"]))
// {
// 	$routine = $_SESSION["coachRoutines"][$i] ;
// }
// else
// {
// 	$i = $i - count($_SESSION["coachRoutines"]);
// 	$routine = $_SESSION["defaultRoutines"][$i] ;
// }
$routineId = $_POST['routineId'];
$routineType = $_POST['routineType'];
$routine = getRoutineObject($routineId, $routineType);

if(isset($_POST['assign'])){ 
	$userSelected = $_POST['userSelected'];
	assign($currentUser, $routine, $routineType, $userSelected) ; 
}else if(isset($_POST['unassign'])){ 
	$userSelected = $_POST['userSelected'];
	unassign($routine, $routineType, $userSelected, $currentUser) ;
}else if(isset($_POST['delete'])){ 
	delete($currentUser, $routine, $routineType) ;
}else if(isset($_POST['edit'])){ 
	edit($currentUser, $routine, $routineType) ; 
}


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


/*
* Major Functions. Edit, Assign, Unassign, Delete. 
*/
function edit($currentUser, $routine, $type){
	$command = $routine->get("command") ;
	$name = $type;
	
	echo $name.'='.$command.'&routine='.$routine->getObjectId() ;
}

function delete($currentUser, $routine, $type){
	//Delete the routine!
	$command = $routine->get("command") ;
	($type == 'default') ? $query = new ParseQuery("DefaultRoutine") : $query = new ParseQuery("CustomRoutine");

	$firstChar = substr($command, 0 , 1) ;
	$type = ($firstChar == 'U') ? "Custom" : "Default" ;
	if($type == "Custom") $query = new ParseQuery("CustomRoutine");
	else $query = new ParseQuery("DefaultRoutine");
			
	$query->equalTo("command", $command);
	$query->equalTo("creator", $currentUser) ;
	//$routineId = $routine->getObjectId() ;
	//$query->equalTo("objectId", $routineId) ;
	$obj = $query->first();
	try {
		$obj->destroy() ;
		echo "true";
	} catch (ParseException $ex) {  
		// Execute any logic that should take place if the save fails.
		// error is a ParseException object with an error code and message.
		echo 'Failed to delete, with error message: ' . $ex->getMessage();
	}
}

function unassign($routine, $type, $playerId, $curUser)
{
	//delete selected player from routine selected. 
	$query = new ParseQuery("AssignedRoutines");
	$players = $_SESSION['allPlayers'];

	$isPlayer = false;
	$userObjectId;

	for ($i=0; !$isPlayer && $i < count($players); $i++) { 
		if($players[$i]->getObjectId() == $playerId){
			$userObjectId = $players[$i];
			$isPlayer = true;
		}
	}

	$query->equalTo("assignedBy", $curUser);
	($type == 'default') ? $query->equalTo("defaultRoutine", $routine) : $query->equalTo("customRoutine", $routine);
	$query->equalTo("user", $userObjectId);
	//Here we will have the object to be deleted. 
	$results = $query->find();
	try {
		$results[0]->destroy();
		echo "true";
		if ($type == 'default') {
			$defaultPls = $_SESSION['playersDefault'][$routine->getObjectId()];
			$isPlayer = false;
			for ($i=0; !$isPlayer && $i < count($defaultPls); $i++) { 
				if($defaultPls[$i] == $userObjectId){
					//This is the position of the user we need to unset from our array
					unset($defaultPls[$i]);
					//Rearrange the array
					$defaultPls = array_values($defaultPls);
					$isPlayer = true;
				}
			}
			$_SESSION['playersDefault'][$routine->getObjectId()] = $defaultPls;
		} else {
			$customPls = $_SESSION['playersCustom'][$routine->getObjectId()];
			$isPlayer = false;
			for ($i=0; !$isPlayer && $i < count($customPls); $i++) { 
				if($customPls[$i] == $userObjectId){
					//This is the position of the user we need to unset from our array
					unset($customPls[$i]);
					//Rearrange the array
					$customPls = array_values($customPls);
					$isPlayer = true;
				}
			}
			$_SESSION['playersCustom'][$routine->getObjectId()] = $customPls;
		}
	} catch (ParseException $ex) {  
		// Execute any logic that should take place if the save fails.
		// error is a ParseException object with an error code and message.
		echo 'Failed to create new object, with error message: ' . $ex->getMessage();
	}
}

function assign($currentUser, $routine, $routType, $playerId)
{
		$link = new ParseObject("AssignedRoutines");
		$link->set("assignedBy", $currentUser);

		$command = $routine->get("command") ;
		$firstChar = substr($command, 0 , 1) ;
		$type = ($firstChar == 'U') ? "Custom" : "Default" ;
		$link->set("type", $type);
		
		$link->set("customRoutine", ($type == "Custom") ? $routine : null);
		$link->set("defaultRoutine", ($type == "Default") ? $routine : null);
		

		$players = $_SESSION['allPlayers'];

		$userObjectId;
		$isPlayer = false;
		for ($i=0; !$isPlayer && $i < count($players); $i++) { 
			if($players[$i]->getObjectId() == $playerId){
				$userObjectId = $players[$i];
				$isPlayer = true;
			}
		}

		$link->set("user", $userObjectId);

		try {
			$link->save();
			echo 'true';
			// If succesful go ahead and push this new player to our session variable
			($routType == 'default') ? array_push($_SESSION['playersDefault'][$routine->getObjectId()], $userObjectId) : array_push($_SESSION['playersCustom'][$routine->getObjectId()], $userObjectId);
		} catch (ParseException $ex) {  
			// Execute any logic that should take place if the save fails.
			// error is a ParseException object with an error code and message.
			echo 'Failed to create new object, with error message: ' . $ex->getMessage();
		}
}

?>