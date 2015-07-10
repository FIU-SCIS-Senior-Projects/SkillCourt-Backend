<!DOCTYPE html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>SkillCourt Simulator</title>
		<meta name="Generator" content="Processing" />
        <link rel="stylesheet" type="text/css" href="style/Wizard.css">
		<script src="processing.js" type="text/javascript"></script>
        <script src="customWizard.js"></script>
		</head>
	<body>
		<!--<ul id="nav">
			<li><a href=#>Home</a></li>
			<li><a href=#>Simulator</a></li>
			<li><a href=#>Wizard</a></li>
			<li><a href=#>Login</a></li>
			<li><a href=#>Register</a></li>
		</ul>-->
		<div id="Header"> 
            SkillCourt Custom Routine Wizard 
        </div>	
		<p id="command"></p>
		<div id="Simulator">
				<br><br><br>
				<canvas id="sketch" data-processing-sources="customWizard/customWizard.pde" width="600" height="600">
					<p>Your browser does not support the canvas tag.</p>
				</canvas>
				<noscript>
					<p>JavaScript is required to view the contents of this page.</p>
				</noscript>
		</div>
		<div id="WizardOptions">
			<ul>
				<li class="blockButtons clicked">
					<select id="stepType" onchange="changeDescription();">
						<option name="description" value="set">Target Set</option>
						<option name="description" value="ground">Ground Target</option>
					</select>
					<p id="stepDescription">Select a group of pads to make up a target. Your pads must be adjacent and on the same wall. When the correct pads are selected, press the 'Finish Step' button.</p>
				</li>
				<li class="buttons clicked">
					<button id="stepArrowLeft" onclick="prevStep();"><</button>
					Step&nbsp;
					<span id="stepNumber"></span>
					of&nbsp;
					<span id="totalSteps"></span>
					<button id="stepArrowRight" onclick="nextStep();">></button>
					<button id="addStep" onclick="addStep();" title="Click to add a new Step">+</button>
				</li>
				<li class="buttons clicked">
					<button id="roundArrowLeft" onclick="prevRound();"><</button>
					Round&nbsp;
					<span id="roundNumber"></span>
					of&nbsp;
					<span id="totalRounds"></span>
					<button id="roundArrowRight" onclick="nextRound();">></button>
					<button id="addRound" onclick="addRound();" title="Click to add a new Round">+</button>
				</li>
				<li class="blockButtons clicked">
					<button id="DeleteStep" onclick="deleteStep();">Delete Step</button>
					<button id="DeleteRound" onclick="deleteRound();">Delete Round</button>
				</li>
				<li class="blockButtons wide clicked">
					<button id="EditStep" onclick="editStep();">Edit Step</button>
					<button id="FinishStep" onclick="finishStep();">Finish Step</button>
				</li>
				<li class="blockButtons wide clicked" >
					<button id="FinishRoutineButton" onclick="finishRoutine();">Finish Routine</button>
				</li>
				<li id="Warning">
				</li>
			</ul>
		</div>
		<script>		
		</script>
	</body>
</html>