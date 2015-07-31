<?php
include_once("parseHeader.php");
use Parse\ParseObject ;
use Parse\ParseUser;
use Parse\ParseQuery ;

$twc = "Your target is one of three walls! Try to keep up!" ;
$chase = "Chase the green light around the room while avoiding the red ones!" ;
$fly = "Your targets are in the air this time!  Aim high to hit your target." ;
$gc = "Dribble towards the green light for the next one to appear! Stay off red lights!" ;
$hc = "Activate the floor target and then chase the green light around the room while avoiding the red ones!" ;
$hf = "Activate the floor target and then look up! Your targets are in the air this time so fly the ball high." ; 
$xcue = "Activate the two floor targets and anticipate the wall targets using the yellow lights. When they become green, fly the ball high!" ;

$currentUser = ParseUser::getCurrentUser();

if(!isset($_SESSION["assignedRoutines"]) or !isset($_SESSION["myPlayers"]))
{
	refreshMyPlayers($currentUser) ;
	refreshAssignedRoutines($currentUser) ;
}

if(isset($_SESSION["coachRoutines"]) and isset($_SESSION["defaultRoutines"]))
{
	if(isset($_GET["i"]))
	{
		$i = $_GET["i"] ;
		$routine ;
		
		if($i < count($_SESSION["coachRoutines"]))
		{
			$routine = $_SESSION["coachRoutines"][$i] ;
		}
		else
		{
			$i = $_GET["i"] - count($_SESSION["coachRoutines"]);
			$routine = $_SESSION["defaultRoutines"][$i] ;
		}
		
		echo '<select id="playerSelect">' ;
		for($j = 0 ; $j < count($_SESSION["assignedRoutines"]) ; $j++)
		{
			$link = $_SESSION["assignedRoutines"][$j] ;
			
			$linkedRoutineType = $link->get("type") ;
			$linkedRoutine = ($linkedRoutineType == "Custom") ? $link->get("customRoutine") : $link->get("defaultRoutine") ;
			$linkedRoutineId = $linkedRoutine->getObjectId() ;
			if($linkedRoutineId == ($routine->getObjectId()))
			{
				$linkUser  = $link->get("user") ;
				$linkUserId = $linkUser->getObjectId() ;
				for($k = 0 ; $k < count($_SESSION["myPlayers"]) ; $k++)
				{
					$playerLink = $_SESSION["myPlayers"][$k] ;
					$player = $playerLink->get("player") ;
					$playerId = $player->getObjectId() ;
					if($linkUserId == $playerId)
					{
						echo '<option value="'.$playerId.'">' ;
						echo $playerLink->get("playerUsername") ;
						echo'</option>' ;
					}
				}
			}
		}
		echo '</select>' ;
		echo '<textarea id="description" readonly>'; 
		echo $routine->get("description") ;
		echo '</textarea>' ;
	}
	else if(isset($_GET["assign"]))
	{
		refreshMyPlayers($currentUser) ;
		//echo count($_SESSION["myPlayers"]) ;
		for($p = 0 ; $p < count($_SESSION["myPlayers"]) ; $p++)
		{
			$playerLink = $_SESSION["myPlayers"][$p] ;
			$player = $playerLink->get("player") ; 
			$playerId = $player->getObjectId() ;
			echo '<option value="'.$playerId.'">' ;
			echo $playerLink->get("playerUsername") ;
			echo '</option>' ;
		}
	}
}	
else{
	echo "ERROR not set in SESSION" ;
}

function refreshMyPlayers($currentUser) {
	$query = new ParseQuery("SignedPlayer");
	$query->equalTo("coach", $currentUser) ;
	$_SESSION["myPlayers"] = $query->find() ;
	//print_r($_SESSION["myPlayers"]);
}

function refreshAssignedRoutines($currentUser) {
	$query = new ParseQuery("AssignedRoutines") ;
	$query->equalTo("assignedBy", $currentUser) ;
	$_SESSION["assignedRoutines"] = $query->find() ;
}

function refreshRoutines($currentUser) {
	$query = new ParseQuery("CustomRoutine") ;
	$query->equalTo("creator" , $currentUser) ;
	$_SESSION["coachRoutines"] = $query->find() ;
	$query = new ParseQuery("DefaultRoutine") ;
	$query->equalTo("creator" , $currentUser) ;
	$_SESSION["defaultRoutines"] = $query->find() ;
}
?>