$(document).ready(function(){
	$("#FinishDefaultEdit").click(function(){
		if(validateDefault())
		{
			console.log("valid");
			var toSend = "editDefault="+prepareMessage() ;
			toSend += "&routineId="+routineId ;
			$.post("createRoutine.php", toSend, function(data,status){
				console.log(data) ;
				window.location.assign('coachRoutines.php');
			});
		}
	});
	$("#FinishDefault").click(function(){
		if(validateDefault())
		{
			console.log("valid");
			$.post("createRoutine.php", "newDefault="+prepareMessage(), function(data,status){
				console.log(data) ;
				window.location.assign('coachRoutines.php');
			});
		}
	});
	$("#switchWrapper button").click(function(){
		var type = $(this).find("span").text() ;
		console.log(type) ;
		if(type != "Custom") {	
			$(this).find("span").text("Custom") ;
			$("#Simulator").fadeOut() ;
			$("#WizardOptionsWrapper").animate({
					left: '450px'
			},"slow");
			$("#WizardOptions").hide();
			$("#DefaultOptions").show();
		}
		else {
			$(this).find("span").text("Default") ;
			$("#Simulator").fadeIn() ;
			$("#WizardOptionsWrapper").animate({
					left: '900px'
			});
			$("#DefaultOptions").hide();
			$("#WizardOptions").show();
		}
	});
	$("#timedRoundsCheckbox input").click(function(){
		$("#timedRoundInput").fadeToggle() ;
	});
	$("#removeWallSelect").change(function(){
		var wall = $(this).val();
		if(wall != 0) 
		{
			if($("#routineSelect").val() == "x")
				$("#routineSelect").val("t");
			$("#routineSelect option[value='x']").hide() ;
		}
		else
		{
			$("#routineSelect option[value='x']").show() ;
		}
	});
	
	$("#routineSelect").change(function(){
		var routine = $(this).val() ;
		if(routine == "c" || routine =="h")	disableRounds() ;
		else enableRounds() ;
	});
});	

function disableRounds(){
	var trLine = $("#timedRoundsCheckbox") ;
	trLine.css("visibility","hidden");
	
	var trCheck = trLine.find("input") ;
	if(trCheck.prop('checked')) 
		$("#timedRoundInput").css("visibility","hidden");
		
	var gameTypeSelect = $("#playByType");
	gameTypeSelect.val("time");
	gameTypeSelect.prop('disabled','true') ;
}

function enableRounds(){
	var trLine = $("#timedRoundsCheckbox") ;
	trLine.css("visibility","visible");
	
	var trCheck = trLine.find("input") ;
	if(trCheck.prop('checked')) 
		$("#timedRoundInput").css("visibility","visible");
		
	var gameTypeSelect = $("#playByType");
	gameTypeSelect.removeAttr('disabled') ;
}

function timedRoundsAreActive()
{
	return ($("#timedRoundInput").css("visibility") != "hidden") 
	&& ($("#timedRoundsCheckbox input").prop('checked')) ;
}
function validateDefault(){
	var obj = document.getElementById("actualTimedRoundInput") ;
	if(timedRoundsAreActive()&&(!obj.checkValidity() || obj.value.length == 0))
	{
		alert("Please enter a number 1-30 for Timed Rounds");
		return false; 
	}
	
	var typeInput = document.getElementById("playByTypeInput") ;
	if(!typeInput.checkValidity() || typeInput.value.length == 0)
	{
		alert("Please enter a number 1-30 for Play By " + $("#playByType").val());
		return false; 
	}
	
	var description = $("#defaultDescription").val();
	var name = $("#defaultName").val();
	if(name.length < 1 || description.length < 1)
	{
		alert("Your Routine must have a name and description");
		return false ;
	}
	
	return true ;
}

function prepareMessage(){
	var description = $("#defaultDescription").val();
	var name = $("#defaultName").val();
	var removedWall = $("#removeWallSelect").val();
	var routineType = $("#routineSelect").val();
	var difficulty = $("#difficultyRadio input:radio:checked").val();
	var timedRound = (timedRoundsAreActive()) 
		? $("#actualTimedRoundInput").val() : "0" ;
	var rounds ;
	var minutes ;
	if($("#playByType option:selected").val() == "time"){
		minutes = $("#playByTypeInput").val() ;
		rounds = 0 ;
	} else {
		rounds = $("#playByTypeInput").val() ;
		minutes = 0 ;
	}
	
	var message = "";
	var command	= "";

	command += (routineType + difficulty);
	command += ((rounds > 9) ? "" : "0") + rounds.toString() ;
	command += (removedWall < 1) ? "00" : "1" + removedWall.toString();
	command += ((minutes > 9 ) ? "0" : "00")+ minutes.toString() ;
	command += ((timedRound > 9) ? "" : "0") + timedRound.toString() ;
	
	message += command ;
	message += "&description=" + description ;
	message += "&name=" + name ;
	message += "&removedWall=" + removedWall ;
	
	message += "&routineType=" ;	
	switch(routineType)
	{
		case "t": message += "Three Wall Chase" ; break ;
		case "c": message += "Chase" ; break ;
		case "h": message += "Fly" ; break ;
		case "g": message += "Home Chase" ; break ;
		case "j": message += "Home Fly" ; break ;
		case "m": message += "Ground Chase" ; break ;
		case "x": message += "X-Cue" ; break ;
	}
	
	message += "&difficulty=" ; 
	
	switch(difficulty)
	{
		case "n" : message += "Novice" ; break ;
		case "i" : message += "Intermediate" ; break ;
		case "a" : message += "Advanced" ; break ;
	}
	
	message += "&timedRound=" + timedRound ;
	message += "&minutes=" + minutes ;
	message += "&rounds=" + rounds ;
	
	return message ;
}

function fillInOptions(){
	var routineType = defaultToEdit.substring(0,1) ;
	var difficulty = defaultToEdit.substring(1,2) ;
	var rounds = defaultToEdit.substring(2,4) ;
	var isWallMissing = defaultToEdit.substring(4,5);
	var removedWall = defaultToEdit.substring(5,6);
	var time = defaultToEdit.substring(6,9) ;
	var timePerRound = defaultToEdit.substring(9,11) ;
	
	$("#routineSelect").val(routineType);
	
	if(rounds == 0) {
		$("#playByInput").val(time) ;
		$("#playByType").val("time") ;
	} else {
		$("#playByInput").val(rounds) ;
		$("#playByType").val("rounds") ;
	}
	
	$("#difficultyRadio input[value='"+difficulty+"']").prop('checked','true');
	
	if(timePerRound > 0) {
		$("#timedRoundInput").show().prop('checked','true') ;
	}
	$("#actualTimedRoundInput").val(timePerRound);
	
	if(isWallMissing < 1) {
		$("#removeWallSelect").val("0");
	} else {
		$("#removeWallSelect").val(removedWall);
	}
	
	$("#DefaultOptions li:first").hide() ;
	$("#DefaultOptions ul li:nth-last-of-type(2)").hide() ;
	var description = $("#defaultDescription").val("placeholder");
	var name = $("#defaultName").val("placeholder");
}