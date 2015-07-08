<?php
    $isCustom = isset($_GET['rc']);
?>
<!DOCTYPE html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>SkillCourt Simulator</title>
		<meta name="Generator" content="Processing" />
        <link rel="stylesheet" type="text/css" href="style/Simulator.css">
		<script src="processing.js" type="text/javascript"></script>
	</head>
	<body>
		<div id="Header"> 
            SkillCourt Simulator 
            </div>
		</div>	
		<div id="SimSettings">
			<ul id="tabs">
				<li>
					<button onclick="showDefault();">Default</button>
				</li>
				<li>
					<button onclick="showCustom();">Custom</button>
				</li>
			</ul>
			<div class="SettingsList" id="CustomList">
				<ul>
					<li>
						<input id="commandInput" type="text"></input>
					</li>
					<li><button onclick="quickStartGame();">Play!</button></li>
				</ul>
			</div>
			<div class="SettingsList" id="DefaultList">
				<p>SkillCourt Routines</p>
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
						<input id="timePerRound" type="number" min="1" max="30" disabled>
						seconds</li>
					<li>Play By</li>
					<li>
						<select id="gameType">
							<option value="time" selected="true">Time (minutes)</option>
							<option value="rounds">Rounds</option>
							<input type="number" id="amount" min="1" max="30" value="1">
						</select></li>
					<li ><button onclick="startGame();">Play!</button></li>
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
				<canvas id="sketch" data-processing-sources="simulator/simulator.pde" width="600" height="600">
					<p>Your browser does not support the canvas tag.</p>
				</canvas>
				<noscript>
					<p>JavaScript is required to view the contents of this page.</p>
				</noscript>
		</div>
		<script src="buzz.min.js"></script>
        <script src="simulator.js"></script>
        <script>
                <?php if($isCustom): ?>
                    document.getElementById("SettingsList").style.display = "none" ;
                    document.getElementById("CustomPlay").style.display = "block" ;
                    customRoutineCommand = <?php echo "\"".$_GET['rc']."\"" ?>;
                    customCoachRoutine = true;
                <?php endif ; ?>
            console.log(customRoutineCommand) ;
        </script>
	</body>
</html>