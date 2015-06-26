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
var northRoundsForWizard;
var eastRoundsForWizard;
var timeForWizard;
var roundsForWizard;
var routineType;
var customCommand;

document.getElementById("removedWall").style.display = "none" ;
	
function allowRounds()
{
	var routineObj = document.getElementById("routineType");
    if(routineObj.value == "c" || routineObj.value == "h"){
		document.getElementById("timePerRoundCheck").disabled = true ;
		document.getElementById("timePerRoundCheck").checked = false ;
		document.getElementById("timePerRound").value = NaN ;
        document.getElementById("timePerRound").disabled = true;
	}
	else
	{
		if(document.getElementById("timePerRoundCheck").disabled)
		{
			//document.getElementById("gameType").disabled = false ;
			document.getElementById("timePerRoundCheck").disabled = false ;
		}
        
	}
    
    showGameType();
}

function showGameType()
{
    console.log("on click");
    
    var wizardW  = document.getElementById("wizardWalls");
    var gameType  = document.getElementById("gameTypePlayBy");
    var amount  = document.getElementById("amount");
    var playBy  = document.getElementById("playBy");
    var routineObj = document.getElementById("routineType");
    
    if (routineObj.value == "t"){
        wizardWalls.style.display = "none";
        gameType.style.display = "block";
        amount.style.display = "block";
        playBy.style.display = "block";
        playBy.style.display = "block";
    } else if (routineObj.value == "c" || routineObj.value == "h"){
        wizardWalls.style.display = "block";
        gameType.style.display = "none";
        amount.style.display = "none";
        playBy.style.display = "none";
        
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
		document.getElementById("routineType").value = "m" ;	
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
        //console.log("is not time based");
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
		var roundsObj = document.getElementById("timeAmount");
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

function isTimeBased(){
    
    if (document.getElementById("timeForGameType").selected){
        console.log("is time based: ");
        return true;
    }else{
        console.log("is not time based");
        return false;
    }
}

function checkMissingWall()
{
	if(document.getElementById("customRoomCheck").checked)
		missingWall = document.getElementById("removedWall").value ;
	else 
		missingWall = -1 ;
}

function getTimeForGame()
{
    if (isTimeBased()){
        var time = document.getElementById("amount");
        if (time.checkValidity()) return parseInt(time.value);
        else return 1;
    }
    return 0;
}

function getNorthRoundsForWizard()
{
    var roundsWiz = document.getElementById("amountOfNorthRoundsWizard");
    if (roundsWiz.checkValidity()) return parseInt(roundsWiz.value);
    else return 1;
}

function getEastRoundsForWizard()
{
    var roundsWiz = document.getElementById("amountOfEastRoundsWizard");
    if (roundsWiz.checkValidity()) return parseInt(roundsWiz.value);
    else return 1;
}

function startWizard()
{
    processingInstance = Processing.getInstanceById('sketch');
    processingInstance.setJavaScript(this);
    
    
    isReadyToPlay=true ;
    
    northRoundsForWizard = getNorthRoundsForWizard();
    eastRoundsForWizard = getEastRoundsForWizard();
    timeForWizard = getTimeForGame();
    roundsForWizard = getRounds();
    console.log("roundsForWizard: "+ roundsForWizard);
    console.log("timeForWizard: "+timeForWizard);
    routineType = getRoutine();
    
    
    checkMissingWall();
    
    difficultyForGame = getDifficulty() ;
    
    routineCommand = routineType + difficultyForGame;
}

function selectPad()
{
    selectPressedPad = true;
    selectNewWall = true;
}


function stopGame()
{
	processingInstance.reset();
	postFeedback(0,0,0,0,0,0,0,0);
	document.getElementById("routineType").firstChild.selected = "true" ;
	document.getElementById("SettingsList").style.display = "block" ;
	document.getElementById("FeedbackList").style.display = "none" ;
}

function switchButtonToPlay(){
    
    document.getElementById("startWizard").style.display = "none";
    document.getElementById("playCustomRoutine").style.display = "block";
    
}

function playCustomRoutine()
{
    window.location.assign("simulator.php?rc="+customCommand);
}

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
