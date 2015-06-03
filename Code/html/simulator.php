<!DOCTYPE html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>SkillCourt Simulator</title>
		<meta name="Generator" content="Processing" />
        <link rel="stylesheet" type="text/css" href="style/Main.css">
	<script src="processing.js" type="text/javascript">
		
	</script>
	<script type="text/javascript">
		// convenience function to get the id attribute of generated sketch html element
		routineCommand = "" ;
		warning=""; 
		var isReadyToPlay =false ; 
		function getProcessingSketchId () { return 'sketch'; }
	</script>
	</head>
	<body>
		<div id="Header"> 
            SkillCourt Simulator 
        </div>
		
		<div id="SimSettings">
			<table>
				<tr>
					<td>Routine</td>
					<td><select id="routineType" onchange="allowRounds();">
								<option value="t"selected="true">Three Wall Chase</option>
								<option value="c">Chase</option>
								<option value="h">Fly</option>
								<option value="g">Home Chase</option>
								<option value="j">Home Fly</option>
								<option value="m">Ground Chase</option>
							</select></td>
					<td id="gametypeMsg"></td>
				</tr>
				<tr>
					<td>Difficulty</td>
					<td>
						<input  type="radio" name="difficulty" value="n" checked="true">Novice<br>
						<input type="radio" name="difficulty" value="i">Intermediate<br>
						<input type="radio" name="difficulty" value="a">Advanced</td>
					<td></td>
				</tr>
				<tr>
					<td>Time Per Round</td>
					<td><input id="timePerRoundCheck" type="checkbox" onchange="myFunction2();">
						<input id="timePerRound" type="number" min="1" max="30" disabled></td>
				</tr>
				<tr>
					<td>Play By</td>
					<td>
						<select id="gameType">
							<option value="time" selected="true">Time (minutes)</option>
							<option value="rounds">Rounds</option>
							<input type="number" id="amount" min="1" max="30" value="1">
						</select>
				</tr>
				<tr>
					<td></td>
					<td><button onclick="startGame();">Start</button></td>
					<td><button onclick="switchOff();">Off</button></td>
				</tr>
			</table>	
		</div>	
		<p id="output"></p>
		<div id="Simulator">
			<div>
				<br><br><br>
				<canvas id="sketch" data-processing-sources="simulator/simulator.pde" width="600" height="600">
					<p>Your browser does not support the canvas tag.</p>
				</canvas>
				<noscript>
					<p>JavaScript is required to view the contents of this page.</p>
				</noscript>
			</div>
		</div>
		<script type="application/javascript">
			function allowRounds()
			{
				var routineObj = document.getElementById("routineType");
				if(routineObj.value == "c" || routineObj.value == "h")
				{
					document.getElementById("gameType").value = "time" ;
					document.getElementById("gameType").disabled = true ;
					document.getElementById("timePerRoundCheck").disabled = true ;
				}
				else
				{
					document.getElementById("gameType").disabled = false ;
					document.getElementById("timePerRoundCheck").disabled = false ;
				}
			}
			function myFunction2() {
				var x = document.getElementById("timePerRound").disabled;
				document.getElementById("timePerRound").disabled = !x ;
				document.getElementById("timePerRound").value = NaN ;
			}
			
			var routineForGame ;
			var difficultyForGame ;
			var timePerRound ;
			var timeForGame ;
			var roundsForGame ;
			
			function getRoutine()
			{
				return document.getElementById("routineType").value ;
			}
			
			function getDifficulty()
			{
				var difficulties = document.getElementsByName("difficulty") ;
				for(var i = 0 , len = difficulties.length ; i < len ; i++)
					if(difficulties[i].checked)
						return difficulties[i].value ;
			}
			
			function getRounds() 
			{
				if(!isTimeBased()) 
				{
					var roundsObj = document.getElementById("amount");
					if (roundsObj.checkValidity() == false) {isReadyToPlay = false ;warning = roundsObj.validationMessage ;}
					else return parseInt(roundsObj.value) ;
				}
				return 0 ;
			}			
			
			function getMinutes()
			{
				if(isTimeBased()) 
				{
					var roundsObj = document.getElementById("amount");
					if (roundsObj.checkValidity() == false) isReadyToPlay = false ;
					else return parseInt(roundsObj.value) ;
				}
				return 0 ;
			}
			
			function getTimePerRound()
			{
				var timePerRoundObj = document.getElementById("timePerRound") ;
				if(!timePerRoundObj.disabled)
				{
					if(timePerRoundObj.checkValidity() == false) isreadyToPlay = false ;
					else return parseInt(timePerRoundObj.value) ;
				}
				
				return 0 ; 
			}
			
			function isTimeBased(){ return document.getElementById("gameType").value === "time"; }
			
			//delete this at some point or make it work better
			function switchOff(){ isReadyToPlay = false ; }
			

			function startGame()
			{
				isReadyToPlay=true ;
				
				difficultyForGame = getDifficulty() ;
				routineForGame = getRoutine() ;
				roundsForGame = getRounds() ;
				roundsForGameStr = (roundsForGame > 9) ? ("0" + roundsForGame.toString() ) : "00"+roundsForGame.toString() ;
				timeForGame = getMinutes() ;
				timeForGameStr = (timeForGame > 9 ) ? ("00" + timeForGame.toString()) : "000"+ timeForGame.toString();
				timePerRound = getTimePerRound() ;
				timePerRoundStr = (timePerRound > 9 ) ? (timePerRound.toString()) : "0"+ timePerRound.toString(); 
				
				routineCommand = routineForGame + difficultyForGame + roundsForGameStr  + timeForGameStr + timePerRoundStr ; 
				
				document.getElementById("output").innerHTML = routineForGame + difficultyForGame + roundsForGameStr  + timeForGameStr + timePerRoundStr ; 
			}
		</script>
	</body>
</html>
