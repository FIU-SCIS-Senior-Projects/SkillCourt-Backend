<!DOCTYPE html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>SkillCourt Simulator</title>
		<meta name="Generator" content="Processing" />
        <link rel="stylesheet" type="text/css" href="style/Simulator.css">
	<script src="processing.js" type="text/javascript">
	</script>
	</head>
	<body>
		<div id="Header"> 
            SkillCourt Simulator 
        </div>
		<div id="SimSettings">
			<div id="SettingsList">
				<p>SkillCourt Routines</p>
				<ul>
					<li>Choose a Routine:</li>
					<li><select id="routineType" onchange="allowRounds();">
								<option value="t"selected="true">Three Wall Chase</option>
								<option value="c">Chase</option>
								<option value="h">Fly</option>
								<option value="g">Home Chase</option>
								<option value="j">Home Fly</option>
								<option value="m">Ground Chase</option>
								<option value="x">X-Cue</option>
							</select></li>
					<li>Choose the Difficulty:</li>
					<li>
						<input  type="radio" name="difficulty" value="n" checked="true">Novice<br>
						<input type="radio" name="difficulty" value="i">Intermediate<br>
						<input type="radio" name="difficulty" value="a">Advanced</li>
					<li>Time Per Round</li>
					<li><input id="timePerRoundCheck" type="checkbox" onchange="myFunction2();">
						<input id="timePerRound" type="number" min="1" max="30" disabled></li>
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
					<li>Anticipation Reaction Time: <span id="arTimeNum"></span></li>
					<li><button>PAUSE</button></li>
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
		<script type="text/javascript">
			var routineCommand = "" ;
			var warning=""; 
			var isReadyToPlay =false ;
			var routineForGame ;
			var difficultyForGame ;
			var timePerRound ;
			var timeForGame ;
			var roundsForGame ;
			var processingInstance ;
			
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

			function startGame()
			{
				processingInstance = Processing.getInstanceById('sketch');
				processingInstance.setJavaScript(this);
				
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
				
				document.getElementById("SettingsList").style.display = "none" ;
				document.getElementById("FeedbackList").style.display = "block" ;
			}
			
			function postFeedback(successesNum, missesNum, minusNum, accuracyNum, forceNum, arTimeNum)
			{
				document.getElementById("successesNum").innerHTML = successesNum ;	
				document.getElementById("missesNum").innerHTML = missesNum ;	
				document.getElementById("minusNum").innerHTML = minusNum ;	
				document.getElementById("accuracyNum").innerHTML = (accuracyNum.toFixed(2) + "%") ;	
				document.getElementById("forceNum").innerHTML = (forceNum.toFixed(2) + " N") ; 	
				document.getElementById("arTimeNum").innerHTML = ((arTimeNum/1000).toFixed(2) + " seconds") ;	
			}
		</script>
	</body>
</html>
