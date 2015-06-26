<!DOCTYPE html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>Routine Wizard</title>
		<meta name="Generator" content="Processing" />
        <link rel="stylesheet" type="text/css" href="style/Simulator.css">
		<script src="processing.js" type="text/javascript"></script>
	</head>
	<body>
		<div id="Header"> 
            Routine Wizard 
        </div>
		<div id="SimSettings">
			<div id="SettingsList">
				<p>SkillCourt Wizard</p>
				<ul>
					<li><input id="customRoomCheck" type="checkbox" onclick="switchCustom();"/>Remove Wall</li>
					<li><select id="removedWall">
							<option value="1" selected="true">North</option>
							<option value="2">East</option>
							<option value="3">South</option>
							<option value="4">West</option>
						</select></li>	
					<li>Choose a Routine:</li>
					<li><select id="routineType" onchange="allowRounds();">
							<option name="routine" value="t"selected="true">Three Wall Chase</option>
							<option name="routine" value="c">Chase</option>
							<option name="routine" value="h">Fly</option>
							<option name="routine" value="g">Home Chase</option>
							<option name="routine" value="j">Home Fly</option>
							<option name="routine" value="m">Ground Chase</option>
							<option name="routine" value="x">X-Cue</option>
						</select></li>
                    <li>Choose the Difficulty:</li>
                    <li>
                            <input type="radio" name="difficulty" value="n" checked="true">Novice<br>
                            <input type="radio" name="difficulty" value="i">Intermediate<br>
                            <input type="radio" name="difficulty" value="a">Advanced</li>
                            <li>Time Per Round</li>
                            <li><input id="timePerRoundCheck" type="checkbox" onclick="myFunction2();">
                            <input id="timePerRound" type="number" min="1" max="30" disabled></li>
                        <li id="wizardWalls" >Select Rounds:<br>
                            <input type ="number" id="amountOfNorthRoundsWizard" min="1" max="10" value="1"> North South<br>
                            <input type ="number" id="amountOfEastRoundsWizard" min="1" max="10" value="1"> South West<br>
                        </li>
                    <li id="playBy" >Play By</li>
                    <li>
                        <select id="gameTypePlayBy">
                            <option value="timeForGameType" id="timeForGameType" selected="true">Time (minutes)</option>
                            <option value="roundsForGameType">Rounds</option>
                            <input type="number" id="amount" min="1" max="30" value="1">
                        </select></li>
                    <li><button id="startWizard" onclick="startWizard();">Start Wizard!</button></li>
                    <li><button id="playCustomRoutine" onclick="playCustomRoutine();">Play New Routine!</button></li>
					</ul>
			</div>	
			<div id="FeedbackList">
				<p>SkillCourt Performance</p>
				<ul>	
					<li>Successes: <span id="successesNum"><span></li>
					<li>Minus Points: <span id="minusNum"></span></li>
					<li>Misses: <span id="missesNum"></span></li>
					<li>Accuracy: <span id="accuracyNum"></span></li>
					<li>Average Force: <span id="forceNum"></span></li>
					<li>AR Shot Time: <span id="arTimeNum"></span></li>
					<li>AR Dribbling Time: <span id="dribbleTimeNum"></span></li>
					<li>xPRS Speed: <span id="xprs"></span></li>
					<li><button onclick="stopGame();">STOP</button></li>
				</ul> 
			</div>
		</div>	
		<div id="Simulator">
				<br><br><br>
				<canvas id="sketch" data-processing-sources="routineWizard/routineWizard.pde" width="600" height="600">
					<p>Your browser does not support the canvas tag.</p>
				</canvas>
				<noscript>
					<p>JavaScript is required to view the contents of this page.</p>
				</noscript>
		</div>
		<script src="buzz.min.js"></script>
		<script src="simulatorRoutineWizard.js"></script>
	</body>
</html>
