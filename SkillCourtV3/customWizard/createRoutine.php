<?php 
include_once("../inc/parseHeader.php");
use Parse\ParseObject ;
use Parse\ParseUser;
use Parse\ParseQuery ;
use Parse\ParseException ;

$currentUser = ParseUser::getCurrentUser() ;

if(isset($_POST["newCustom"])) createCustom($currentUser) ;
else if(isset($_POST["newDefault"])) createDefault($currentUser) ;
else if(isset($_POST["editCustom"])) editCustom($currentUser);
else if(isset($_POST["editDefault"])) editDefault($currentUser);

function editDefault($currentUser){
	$query = new ParseQuery("DefaultRoutine") ;
	$query->equalTo("objectId",$_POST["routineId"]);
	$obj = $query->first();
	
	$obj->set("command",$_POST["editDefault"]);
	$obj->set("difficulty", $_POST["difficulty"]) ;
	$obj->set("removedWall", intval($_POST["removedWall"])) ;
	$obj->set("rounds", intval($_POST["rounds"])) ;
	$obj->set("routineType", $_POST["routineType"]) ;
	$obj->set("time", intval($_POST["minutes"])) ;
	$obj->set("timePerRound", intval($_POST["timedRound"])) ;
	
	try {
		$obj->save();
		echo 'Success Routine Edit' ; 
	} catch(ParseException $ex) {
		echo 'Failed Routine Edit: '.$ex->getMessage() ;
	}
}

function editCustom($currentUser){
	$query = new ParseQuery("CustomRoutine") ;
	$query->equalTo("objectId",$_POST["routineId"]);
	$obj = $query->first();
	$obj->set("command",$_POST["editCustom"]) ;
	
	try {
		$obj->save();
		echo 'Success Routine Edit' ; 
	} catch(ParseException $ex) {
		echo 'Failed Routine Edit: '.$ex->getMessage() ;
	}
}

function createCustom($currentUser){
	$command = $_POST["newCustom"] ;
	$name = $_POST["name"] ;
	$description = $_POST["description"] ;
	
	$routine = new ParseObject("CustomRoutine");
	$routine->set("command", $command) ;
	$routine->set("creator", $currentUser) ;
	$routine->set("description", $description) ;
	$routine->set("name", $name) ;
	
	try {
		$routine->save();
		echo 'Success Routine Creation' ; 
	} catch(ParseException $ex) {
		echo 'Failed Routine Creation: '.$ex->getMessage() ;
	}
}

function createDefault($currentUser) {

	$routine = new ParseObject("DefaultRoutine") ;
	$routine->set("command", $_POST["newDefault"]) ;
	$routine->set("creator", $currentUser) ;
	$routine->set("description", $_POST["description"]) ;
	$routine->set("name", $_POST["name"]) ;
	$routine->set("difficulty", $_POST["difficulty"]) ;
	$routine->set("removedWall", intval($_POST["removedWall"])) ;
	$routine->set("rounds", intval($_POST["rounds"])) ;
	$routine->set("routineType", $_POST["routineType"]) ;
	$routine->set("time", intval($_POST["minutes"])) ;
	$routine->set("timePerRound", intval($_POST["timedRound"])) ;
	
	try {
		$routine->save();
		echo 'Success Routine Creation' ; 
	} catch(ParseException $ex) {
		echo 'Failed Routine Creation: '.$ex->getMessage() ;
	}
}
?>