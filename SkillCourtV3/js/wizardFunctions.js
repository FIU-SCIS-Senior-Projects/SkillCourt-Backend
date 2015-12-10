//############# CUSTOM WIZARD ################################
var groundTargetDescription = "Select a ground pad for this step. When the correct ground pad is selected, press the 'Finish Step' button.";
var setTargetDescription = "Select many groups of pads to make up targets. Each target is comprised of the pads that share the same wall, only one target per wall. When you are finished, press the 'Finish Step' button.";
var stepWarning = "Please select your targets properly before finishing this step" ;
var roundWarning = "Please finish your steps properly before finishing this round" ;
var routineWarning = "Please finish your rounds properly before finishing this routine" ;
var processingInstance;
var commandToEdit = "" ;
var defaultToEdit = "" ;
var routineId = "";
var step, round, stepTotal, roundTotal;

setTimeout(function()
{
	processingInstance = Processing.getInstanceById("sketch");
	processingInstance.setJavaScript(this);
	
	if(commandToEdit.length > 0 )
	{
		processingInstance.buildWizardFromCommand(commandToEdit) ;
		getStepTotal() ;
		getRoundTotal() ;
		getStepNumber() ;
		getRoundNumber() ;
		checkArrows();
		var type = processingInstance.getCurrentStepType() ;
		//console.log(type) ; 
		//processingInstance.setStepCreator(type) ;
		setDescription(type) ;
		var stepTypeObj = document.getElementById("stepType");
		var descriptionObj = document.getElementById("stepDescription");
		
		switch(stepTypeObj.value)
		{
			case "set": descriptionObj.innerHTML = setTargetDescription; break;
			case "ground": descriptionObj.innerHTML = groundTargetDescription; break;
		}
		setStepButton(false) ;
	}
	else
	{
		getStepNumber() ;
		getRoundNumber() ;
		getStepTotal() ;
		getRoundTotal() ;
		processingInstance.setStepCreator("set") ;
	}
}, 500);


//-----------------FUNCTIONS-------------------------//
function deleteStep(){
	if(stepTotal == 1) 
		document.getElementById("Warning").innerHTML = "You cannot delete your only step!" ;
	else
	{
		document.getElementById("Warning").innerHTML = "" ;
		processingInstance.deleteStep() ;
		getStepNumber() ;
		getStepTotal() ;
		checkArrows() ;
	}
}

function deleteRound(){
	if(roundTotal == 1) 
		document.getElementById("Warning").innerHTML = "You cannot delete your only round!" ;
	else
	{
		document.getElementById("Warning").innerHTML = "" ;
		processingInstance.deleteRound() ;
		getRoundNumber() ;
		getRoundTotal() ;
		getStepNumber() ;
		getStepTotal() ;
		checkArrows() ;
	}
}

function nextStep(){
	processingInstance.nextStep() ; 
	getStepNumber() ;
	checkArrows() ;
}

function prevStep(){
	processingInstance.prevStep() ; 
	getStepNumber() ;
	checkArrows() ;
}

function nextRound(){
	processingInstance.nextRound() ; 
	getRoundNumber() ;
	getStepNumber() ;
	getStepTotal() ;
	checkArrows() ;
}

function prevRound(){
	processingInstance.prevRound() ; 
	getRoundNumber() ;
	getStepNumber() ;
	getStepTotal() ;
	checkArrows() ;
}

function checkArrows(){
	var stepArrL = document.getElementById("stepArrowLeft") ;
	var stepArrR = document.getElementById("stepArrowRight") ;
	var roundArrL = document.getElementById("roundArrowLeft") ;
	var roundArrR = document.getElementById("roundArrowRight") ;
	
	if(step == 1) stepArrL.style.visibility = "hidden" ;
	else stepArrL.style.visibility = "visible" ;
	if(step == stepTotal) stepArrR.style.visibility = "hidden" ;
	else stepArrR.style.visibility = "visible" ;
	
	if(round == 1) roundArrL.style.visibility = "hidden" ;
	else roundArrL.style.visibility = "visible" ;
	if(round == roundTotal) roundArrR.style.visibility = "hidden" ;
	else roundArrR.style.visibility = "visible" ;
}

function addStep(){
	processingInstance.createStep(); 
	getStepTotal() ;
	checkArrows() ;
}

function addRound(){
	processingInstance.createRound() ;
	getRoundTotal() ;
	checkArrows() ;
}

function setStepButton(toFinish){
	document.getElementById("EditStep").style.display = (toFinish) ? "none" : "inline-block" ;
	document.getElementById("FinishStep").style.display = (toFinish) ? "inline-block" : "none" ;	
}

function getStepNumber() {
	step = processingInstance.getCurrentStepNumber() ;
	document.getElementById("stepNumber").innerHTML = step ;
}

function getRoundNumber() {
	round = processingInstance.getCurrentRoundNumber() ;
	document.getElementById("roundNumber").innerHTML = round ;
}

function getStepTotal() {
	stepTotal = processingInstance.getNumberOfSteps() ;
	document.getElementById("totalSteps").innerHTML = stepTotal ;
}

function getRoundTotal() {
	roundTotal = processingInstance.getNumberOfRounds() ;
	document.getElementById("totalRounds").innerHTML = roundTotal ;
}

function getDescription(){
	return document.getElementById("stepType").value ;
}

function setDescription(type){
	document.getElementById("stepType").value = type ;
}

function changeDescription(){
	editStep() ;
	var stepTypeObj = document.getElementById("stepType");
	var descriptionObj = document.getElementById("stepDescription");
	
	processingInstance.setStepCreator(stepTypeObj.value) ;
	
	switch(stepTypeObj.value)
	{
		case "set": descriptionObj.innerHTML = setTargetDescription; break;
		case "ground": descriptionObj.innerHTML = groundTargetDescription; break;
	}
}

function editStep(){
	setStepButton(true) ;
	processingInstance.editStep();
	//document.getElementById("stepType").disabled = false ;
}

function finishStep(){
	if(processingInstance.finishStep())
	{
		setStepButton(false) ;			
		document.getElementById("Warning").innerHTML = "" ;
        
		if(step < stepTotal) nextStep() ;
		//document.getElementById("stepType").disabled = true ;
	}
	else document.getElementById("Warning").innerHTML = stepWarning ;
	
}

function finishRound(){
	processingInstance.finishRound() ;
}

function finishRoutine(){
	if(processingInstance.finishRoutine()) 
	{
		var command = processingInstance.command() ;
		console.log(command) ;
		$("#Simulator").fadeOut('slow',function(){
			var customClass = 'col-lg-6'
			var defaultClass = 'col-lg-6 col-lg-offset-3';
			$("#WizardOptions").hide();
			$("#switchWrapper").hide();
			//We are going to default. Move the wrapper to the middle. 
			$('#divWizardWrapper').removeClass(customClass);
			$('#divWizardWrapper').addClass(defaultClass);
			$("#GetNameDescription").show();
		});

		// $("#Simulator").fadeOut();
		// $("#WizardOptions").fadeOut();
		// $("#switchWrapper").fadeOut();
		// $("#GetNameDescription").fadeIn(function(){
		// 	var customClass = 'col-lg-6'
		// 	var defaultClass = 'col-lg-6 col-lg-offset-3';
		// 	$('#divWizardWrapper').removeClass(customClass);
		// 	$('#divWizardWrapper').addClass(defaultClass);	
		// }) ;
		
		$("#FullFinishRoutine").val(command);
	}
	else
		document.getElementById("Warning").innerHTML = routineWarning ;
}

// This is the finish editing of a custom routine 
function finishEdit(){
	if(processingInstance.finishRoutine()) 
	{
		var command = processingInstance.command() ;
		//console.log(command);
		var toSend = "editCustom=" + command ;
		toSend += "&routineId=" + routineId ;
		$.post("./customWizard/createRoutine.php", toSend, function(data,status){
			window.location.assign('./index.php?show=routinesCoach&controller=routines&action=showRoutines');	
		});
	}
	else
		document.getElementById("Warning").innerHTML = routineWarning ;
}

function roundNotReady() {
	document.getElementById("Warning").innerHTML = roundWarning ;
}

function defaultLock() {
	$(document).ready(function(){
		setTimeout(function(){
			processingInstance.noLoop() 
		},501);;
		
		$("#Simulator").fadeOut() ;
		// $("#WizardOptionsWrapper").animate({
		// 		left: '450px'
		// },"slow");
		$("#WizardOptions").hide();
		$("#DefaultOptions").show();
		fillInOptions() ;
	});
}
//------------------------FINISH ROUTINE---------------------------

$(document).ready(function(){
	$("#FullFinishRoutine").click(function(){
		var description = $("#getDescription").val();
		var name = $("#getName").val();
		if(name.length < 1 || description.length < 1)
		{
			alert("Your Routine must have a name and description");
		}
		else
		{
			var command = $(this).val() ;
			//console.log(command) ;
			var toSend = "newCustom=" + command ;
			toSend += "&name=" + name ;
			toSend += "&description=" + description ;
			$.post("./customWizard/createRoutine.php", toSend, function(data,status){
				//console.log(data) ;
				window.location.assign('./index.php?show=routinesCoach&controller=routines&action=showRoutines');
			});
		}
	});
});