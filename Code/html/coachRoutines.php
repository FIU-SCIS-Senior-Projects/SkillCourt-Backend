<?php

include_once("parseHeader.php");

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;
use Parse\ParseQuery ;
$currentUser = ParseUser::getCurrentUser();
$username;
    
if ($currentUser) {
    //$username = $currentUser->getObjectId();
    //echo $currentUser->getUsername();
    $username = $currentUser->getUsername();
} else {
    // show the signup or login page
    Header('Location:index.php');
}

//begin query for custom routines
$query = new ParseQuery("CustomRoutine") ;
$query->equalTo("creator" , $currentUser) ;
$_SESSION["coachRoutines"] = $query->find() ;

$query = new ParseQuery("DefaultRoutine") ;
$query->equalTo("creator" , $currentUser) ;
$_SESSION["defaultRoutines"] = $query->find() ;

?>
<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
        <title>SkillCourt</title>
        <link rel="stylesheet" type="text/css" href="style/index.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<script src="coachRoutines_jquery.js"></script>
    </head>
    <body>
        <?php include 'navigation_bar.php'; ?>
        <?php include 'card.php'; ?>
        <div id="text">SkillCourt</div>		
		<div id="informationRectangle1">
			<h1 class="page_heading">Coach Routines</h1>		
			<div id="routinesBlock">
				<select id="routineSelect" name="routines" size="10" >
					<?php
						$crSize = count($_SESSION["coachRoutines"]) ;
						for($i = 0 ; $i < $crSize ; $i++)
						{
							$r = $_SESSION["coachRoutines"][$i] ;
							echo '<option value="'.$i.'">'.$r->get("name").'</option>';
						}
						for($i = 0 ; $i < count($_SESSION["defaultRoutines"]) ; $i++)
						{
							$r = $_SESSION["defaultRoutines"][$i] ;
							echo '<option value="'.($i + $crSize).'">'.$r->get("name").'</option>';
						}
					?>
				</select>
				<div id="buttonsBlock">
					<button class="activeButton" id="assignRoutine">Assign</button>
					<button class="activeButton" id="unassignRoutine">Unassign</button><br>
					<button class="activeButton" id="editRoutine">Edit</button>
					<button class="activeButton" id="deleteRoutine">Delete</button>
				</div>
			</div>
			<div id="routinesInfoBlock">
				<p id="playerSelectPar">assigned to:</p>
				<select id="playerSelect">
				</select>
				<textarea id="description" readonly></textarea>
			</div>
			<div id="assignPopup">
				<h3 id="assignPopupHeading">assignPopupHeading</h3>
				<button id="assignPopupClose">&#10006;</button>	
				<select id="assignPlayersSelect" size=10 name="assign[]" multiple>
				</select>
				<button id="assignSubmit">Assign</submit>
				<button id="unassignSubmit">Unassign</submit>
			</div>
		</div>
    </body>
</html>
