<?php
include_once 'parseHeader.php';
use Parse\ParseObject;
use Parse\ParseUser;
use Parse\ParseQuery ;
use Parse\ParseException ;
$currentUser = ParseUser::getCurrentUser() ;

$i = $_POST["i"] ;
$routine ;

if($i < count($_SESSION["coachRoutines"]))
{
	$routine = $_SESSION["coachRoutines"][$i] ;
}
else
{
	$i = $i - count($_SESSION["coachRoutines"]);
	$routine = $_SESSION["defaultRoutines"][$i] ;
}

if(isset($_POST['assign'])) assign($currentUser, $routine) ;
else if(isset($_POST['unassign'])) unassign($routine) ;
else if(isset($_POST['delete'])) delete($currentUser, $routine) ;
else if(isset($_POST['edit'])) edit($currentUser, $routine) ;

function edit($currentUser, $routine){
	$command = $routine->get("command") ;
	$firstChar = substr($command, 0 , 1) ;
	$name = ($firstChar == 'U') ? "custom" : "default" ;
	
	echo $name.'='.$command.'&routine='.$routine->getObjectId() ;
}

function delete($currentUser, $routine){
	$command = $routine->get("command") ;
	$firstChar = substr($command, 0 , 1) ;
	$type = ($firstChar == 'U') ? "Custom" : "Default" ;
	if($type == "Custom") $query = new ParseQuery("CustomRoutine");
	else $query = new ParseQuery("DefaultRoutine");
			
	$query->equalTo("command", $command);
	$query->equalTo("creator", $currentUser) ;
	//$routineId = $routine->getObjectId() ;
	//$query->equalTo("objectId", $routineId) ;
	$obj = $query->first() ;
	try {
		$obj->destroy() ;
		$i = $_POST["i"] ;

		if($i < count($_SESSION["coachRoutines"]))
		{
			unset($_SESSION["coachRoutines"][$i]) ;
			$_SESSION["coachRoutines"] = array_values($_SESSION["coachRoutines"]) ;
		}
		else
		{	
			unset($_SESSION["defaultRoutines"][$i]) ;
			$_SESSION["defaultRoutines"] = array_values($_SESSION["defaultRoutines"]) ;
		}
	} catch (ParseException $ex) {  
		// Execute any logic that should take place if the save fails.
		// error is a ParseException object with an error code and message.
		echo 'Failed to create new object, with error message: ' . $ex->getMessage();
	}
}

function unassign($routine)
{
	$command = $routine->get("command") ;
	$firstChar = substr($command, 0 , 1) ;
	$type = ($firstChar == 'U') ? "Custom" : "Default" ;
	
	$selectedOption = $_POST["unassign"] ;
	for($j = 0 ; $j < count($_SESSION["myPlayers"]) ; $j++)
	{
		$playerLink = $_SESSION["myPlayers"][$j] ;
		$player = $playerLink->get("player") ;
		$playerId = $player->getObjectId() ;
		if($playerId == $selectedOption) 
		{
			$query = new ParseQuery("AssignedRoutines");
			$query->equalTo("user", $player);
			if($type == "Custom") $query->equalTo("customRoutine" , $routine);
			else $query->equalTo("defaultRoutine" , $routine);
			$results = $query->find();
			//echo count($results) ;
			for($r = 0 ; $r < count($results) ; $r++)
			{
				$obj = $results[$r] ;
				for($k = 0 ; $k < count($_SESSION["assignedRoutines"]) ; $k++)
				{
					$link = $_SESSION["assignedRoutines"][$k] ;
					$linkId = $link->getObjectId() ;
					$objId = $obj->getObjectId() ;
					if($linkId == $objId) 
					{
						unset($_SESSION["assignedRoutines"][$k]);
						$_SESSION["assignedRoutines"] = array_values($_SESSION["assignedRoutines"]) ;
					}
				}
				try {
					$obj->destroy() ;
					echo $playerId ;
				} catch (ParseException $ex) {  
					// Execute any logic that should take place if the save fails.
					// error is a ParseException object with an error code and message.
					echo 'Failed to create new object, with error message: ' . $ex->getMessage();
				}
			}
			continue ;
		}
	}
}

function assign($currentUser, $routine)
{
	foreach ($_POST['assign'] as $selectedOption)
	{
		$link = new ParseObject("AssignedRoutines");
		$link->set("assignedBy", $currentUser);
		
		$command = $routine->get("command") ;
		$firstChar = substr($command, 0 , 1) ;
		$type = ($firstChar == 'U') ? "Custom" : "Default" ;
		$link->set("type", $type);
		
		$link->set("customRoutine", ($type == "Custom") ? $routine : null);
		$link->set("defaultRoutine", ($type == "Default") ? $routine : null);
		
		
		for($j = 0 ; $j < count($_SESSION["myPlayers"]) ; $j++)
		{
			$playerLink = $_SESSION["myPlayers"][$j] ;
			$player = $playerLink->get("player") ;
			$playerId = $player->getObjectId() ;
			
			if($playerId == $selectedOption)
			{
				$link->set("user", $player);	 
				echo '<option value="'.$playerId.'">' ;
				echo $playerLink->get("playerUsername") ;
				echo'</option>' ;
				continue ;
			}
		}

		try {
			$link->save();
			array_push($_SESSION["assignedRoutines"] , $link);
		} catch (ParseException $ex) {  
			// Execute any logic that should take place if the save fails.
			// error is a ParseException object with an error code and message.
			echo 'Failed to create new object, with error message: ' . $ex->getMessage();
		}
	}
}
?>