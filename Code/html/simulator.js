var routineCommand = "" ;
var warning=""; 
var isReadyToPlay =false ;
var routineForGame ;
var difficultyForGame ;
var timePerRound ;
var timeForGame ;
var roundsForGame ;
var processingInstance ;
var missingWall ;
var s0 = new buzz.sound( "s0", { formats: [ "ogg", "mp3"] });
var s1 = new buzz.sound( "s1", { formats: [ "ogg", "mp3"] });
var s2 = new buzz.sound( "s2", { formats: [ "ogg", "mp3"] });
var s3 = new buzz.sound( "s3", { formats: [ "mp3"] });
var bound = false;

document.getElementById("removedWall").style.display = "none" ;
	
function allowRounds()
{
	var routineObj = document.getElementById("routineType");
	if(routineObj.value == "c" || routineObj.value == "h")
	{
		document.getElementById("gameType").value = "time" ;
		document.getElementById("gameType").disabled = true ;
		document.getElementById("timePerRoundCheck").disabled = true ;
		document.getElementById("timePerRoundCheck").checked = false ;
		document.getElementById("timePerRound").value = NaN ;
		document.getElementById("timePerRound").disabled = true;
	}
	else
	{
		if(document.getElementById("timePerRoundCheck").disabled)
		{
			document.getElementById("gameType").disabled = false ;
			document.getElementById("timePerRoundCheck").disabled = false ;
		}
	}
}

function switchCustom()
{	
	var routines = document.getElementsByName("routine") ;
	var xCue ;
	for(var i = 0 ; i < routines.length ; i++)
		if(routines[i].value =="x")
			xCue = routines[i] ;
			
	if(document.getElementById("removedWall").style.display == "none")
	{
		document.getElementById("removedWall").style.display = "block";
		xCue.style.display = "none"; 
	}
	else 
	{
		document.getElementById("removedWall").style.display = "none" ;
		xCue.style.display = "block" ;
	}
}		

function myFunction2() 
{
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

function checkMissingWall()
{
	if(document.getElementById("customRoomCheck").checked)
		missingWall = document.getElementById("removedWall").value ;
	else 
		missingWall = -1 ;
}

function startGame()
{
	processingInstance = Processing.getInstanceById('sketch');
	processingInstance.setJavaScript(this);
	
	isReadyToPlay=true ;
		
	checkMissingWall();	
	
	difficultyForGame = getDifficulty() ;
	routineForGame = getRoutine() ;
	roundsForGame = getRounds() ;
	roundsForGameStr = (roundsForGame > 9) ? ("0" + roundsForGame.toString() ) : "00"+roundsForGame.toString() ;
	timeForGame = getMinutes() ;
	timeForGameStr = (timeForGame > 9 ) ? ("00" + timeForGame.toString()) : "000"+ timeForGame.toString();
	timePerRound = getTimePerRound() ;
	timePerRoundStr = (timePerRound > 9 ) ? (timePerRound.toString()) : "0"+ timePerRound.toString(); 
	
	routineCommand = routineForGame + difficultyForGame + roundsForGameStr  + timeForGameStr + timePerRoundStr ; 
	
	if(isReadyToPlay) changeScreen() ;
}

function changeScreen()
{	
	document.getElementById("SettingsList").style.display = "none" ;
	document.getElementById("FeedbackList").style.display = "block" ;
	
	postFeedback(0,0,0,0,0,0);
	if(routineForGame == "m") 
	{
		document.getElementById("missesNum").parentNode.style.display = "none" ;
		document.getElementById("forceNum").parentNode.style.display = "none" ;
	}
	
	if(routineForGame != "t" && difficultyForGame == "n" && timePerRound == 0)
	{
		document.getElementById("minusNum").parentNode.style.display = "none" ;
	}
	
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

function stopGame()
{
	processingInstance.reset();
	postFeedback(0,0,0,0,0,0);
	document.getElementById("routineType").firstChild.selected = "true" ;
	document.getElementById("SettingsList").style.display = "block" ;
	document.getElementById("FeedbackList").style.display = "none" ;
}

/*function bindJavascript() {
	var pjs = Processing.getInstanceById("@@id@@");
    if(pjs != null) {
	pjs.bindJavascript(this);
	bound = true;
	}
	if(!bound) setTimeout(bindJavascript, 250);
}

bindJavascript();*/

function playTest() {
	s3.load();
	s3.play();
}

function playMissSound() {
	s1.load();
	s1.play();
}

function playSuccessSound() {
	s0.load();
	s0.play();
}
