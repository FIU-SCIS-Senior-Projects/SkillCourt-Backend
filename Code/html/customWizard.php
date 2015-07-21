<?php

include_once("parseHeader.php");

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;

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

?>

<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
        <title>SkillCourt Coach Routine Wizard</title>
        <link rel="stylesheet" type="text/css" href="style/index.css">
		<script src="processing.js" type="text/javascript"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		
		<script src="customWizard.js"></script>
	</head>
    <body>
        <?php include 'navigation_bar.php'; ?>
		<div id="Simulator">
			<br><br><br>
			<canvas id="sketch" data-processing-sources="customWizard/customWizard.pde" width="600" height="600">
				<p>Your browser does not support the canvas tag.</p>
			</canvas>
			<noscript>
				<p>JavaScript is required to view the contents of this page.</p>
			</noscript>
		</div>
		<div id="WizardOptionsWrapper">
			<div id="WizardOptions">
				<h1>Custom Options</h1>
				<ul>
					<li>
						<select id="stepType" onchange="changeDescription();">
							<option name="description" value="set">Target Set</option>
							<option name="description" value="ground">Ground Target</option>
						</select>
						<p id="stepDescription">Select a group of pads to make up a target. Your pads must be adjacent and on the same wall. When the correct pads are selected, press the 'Finish Step' button.</p>
					</li>
					<li class="buttonList">
						<button id="stepArrowLeft" class="myButton round" onclick="prevStep();"><</button>
						Step&nbsp;
						<span id="stepNumber"></span>
						of&nbsp;
						<span id="totalSteps"></span>
						<button id="stepArrowRight" class="myButton round" onclick="nextStep();">></button>
						<button id="addStep" class="myButton round" onclick="addStep();" title="Click to add a new Step">+</button>
					</li>
					<li class="buttonList">
						<button id="roundArrowLeft" class="myButton round" onclick="prevRound();"><</button>
						Round&nbsp;
						<span id="roundNumber"></span>
						of&nbsp;
						<span id="totalRounds"></span>
						<button id="roundArrowRight" class="myButton round" onclick="nextRound();">></button>
						<button id="addRound" class=" myButton round" onclick="addRound();" title="Click to add a new Round">+</button>
					</li>
					<li class="buttonList">
						<button id="DeleteStep"  class="myButton" onclick="deleteStep();">Delete Step</button>
						<button id="DeleteRound" class="myButton" onclick="deleteRound();">Delete Round</button>
					</li>
					<li class="buttonList">
						<button id="EditStep" class="myButton wide" onclick="editStep();">Edit Step</button>
						<button id="FinishStep" class="myButton wide" onclick="finishStep();">Finish Step</button>
					</li>	
					<li class="buttonList">
						<button id="FinishRoutineButton" class="myButton wide" onclick="finishRoutine();">Finish Routine</button>
					</li>
					<li id="Warning">
					</li>
				</ul>
			</div>
		</div>	
    </body>
</html>
