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
		<script src="customWizard_jquery.js"></script>
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
		<div id="WizardOptionsWrapper" class="optionsCustom">	
			<?php if (isset($_GET["default"])) : ?>
				<script>
					defaultToEdit = <?php echo '"'.$_GET["default"].'"' ; ?> ;
					routineId = <?php echo '"'.$_GET["routine"].'"';?> ;
					defaultLock() ;
				</script>
			<?php else : ?>
				<?php if(isset($_GET["custom"])) :?>
					<script>
						commandToEdit = <?php echo '"'.$_GET["custom"].'"' ; ?> ;
						routineId = <?php echo '"'.$_GET["routine"].'"';?> ;
						//customLock() ;
					</script>
				<?php else : ?>
					<div id="switchWrapper">
						<button id="routineSwitch" class="round_orange_buttons wide" value="Custom">Switch to <span>Default</span></button>
					</div>	
				<?php endif ?>			
			<?php endif ?>
			
			<div id="WizardOptions" class="innerOptions">
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
						<?php if(isset($_GET["custom"])):?>
							<button id="FinishCustomEdit" class="myButton wide" onclick="finishEdit();">Finish Editing Routine</button>
						<?php else : ?>
							<button id="FinishRoutineButton" class="myButton wide" onclick="finishRoutine();">Finish Custom Routine</button>
						<?php endif ?>
					</li>
					<li id="Warning">
					</li>
				</ul>
			</div>
			<div id="GetNameDescription" class="innerOptions">
				<ul>
					<li>Give Your Routine A Name!</li>
					</br>
					<li><input id="getName" type="text"></li>
					</br></br>
					<li>Describe Your Routine!</li>
					</br>
					<li><textarea id="getDescription"></textarea></li>
					</br></br>
					<li><button id="FullFinishRoutine" class="myButton wide center">Complete!</button></li>
				</ul>
			</div>
			<div id="DefaultOptions" class="innerOptions">
				<h1>Default Options</h1>
				<ul>
					<li>Name: 
						<input type="text" id="defaultName">
					</li>
					</br>
					<li>Routine:
						<select id="routineSelect">
							<option value="t"selected="true">Three Wall Chase</option>
							<option value="c">Chase</option>
							<option value="h">Fly</option>
							<option value="g">Home Chase</option>
							<option value="j">Home Fly</option>
							<option value="m">Ground Chase</option>
							<option value="x">X-Cue</option>
						</select>
					</li>
					</br>
					<li>Play By:
						<select id="playByType">
							<option value="time" selected="true">Time (minutes)</option>
							<option value="rounds">Rounds</option>
						</select>	
						<input type="number" id="playByTypeInput" min="1" max="30" value="1" class="smallInput">
					</li>
					</br>
					<li id="difficultyRadio">Difficulty:</br>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="difficulty" value="n" checked="true">Novice<br>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="difficulty" value="i">Intermediate<br>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="difficulty" value="a">Advanced
						</li>
					</br>
					<li id="timedRoundsCheckbox">Play with Timed Rounds:
						<input type="checkbox">
					</li>
					<li id="timedRoundInput">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input id="actualTimedRoundInput" type="number" min="1" max="30" class="smallInput">
						seconds per round
					</li>
					</br>
					<li>Remove Wall:
					<select id="removeWallSelect">
							<option value="0" selected="true">-None-</option>
							<option value="1">North</option>
							<option value="2">East</option>
							<option value="3">South</option>
							<option value="4">West</option>
						</select>
					</li>	
					</br>
					<li>Description:
						<textarea id="defaultDescription"></textarea>
					</li>
					</br>
					<li class="center">
						<?php if(isset($_GET["default"])):?>
							<button id="FinishDefaultEdit" class="myButton wide">Finish Editing Routine</button>
						<?php else : ?>
							<button id="FinishDefault" class="myButton wide">Finish Default Routine</button>
						<?php endif ?>
					</li>
				</ul>
			</div>
		</div>	
    </body>
</html>
