var currentCommand ;

	$(".scroll button").click(function(){
		$(".scroll button[value='"+ currentCommand+"']").css("background-color","black") ;
		$(this).css("background-color","orange") ;
		currentCommand = $(this).val() ;
	});
$(document).ready(function(){
	//whenever a routine is selected
	$("#routineSelect").change(function()
	{
		//shows button after first routine is selected
		if($("#buttonsBlock").css("visibility") == "hidden")
		{
			$("#buttonsBlock").css("visibility","visible") ;
			$("#buttonsBlock").hide() ;
			$("#buttonsBlock").slideDown() ;
		}
		//slides in info block
		$("#routinesInfoBlock").fadeIn(); 
		//gets info for selected routines
		$.get("getRoutineInfo.php?i=" + $("#routineSelect").val() , function(data, status)
		{
			//console.log(data);
			$("#playerSelect").remove() ;
			$("#description").remove() ;
			$("#playerSelectPar").after(data) ;
			
			var length = $('#playerSelect').children('option').length;
			if(length == 0) { enableDelete() ;} //disabbleUnassign() ; }
			else { disableDelete() ; }//enableUnassign() ; }
		});
	});
                  
    //in case submitPlayerForm Button is clicked
    
                  
                  
	//in case the ASSIGN button is clicked
	$("#assignRoutine").click(function()
	{	
		$("#assignPlayersSelect").attr('multiple');
		$("#assignPlayersSelect").prop('name','assign[]');
		$("#assignSubmit").show() ;
		$("#unassignSubmit").hide() ;
		//prepares heading
		$("#assignPopupHeading").text("Assign \"" + $("#routineSelect option:selected").text() + "\" to the following players:") ;
		//gets names of all players for this coach
		$.get("getRoutineInfo.php?assign" , function(data, status)
		{
			//console.log(data);
			$("#assignPlayersSelect").append(data) ;
			//removes the names of players who already have the routine assigned
			$("#playerSelect option").each(function(){
				var thisVal = $(this).val() ;
				$("#assignPlayersSelect [value='"+thisVal+"']").remove() ;
			});
		});
		$("#assignPopup").fadeIn() ;
	});
	$("#assignPopupClose").click(function()
	{
		clearAssignPopup() ;
	});
	//in case ASSIGN is submitted
	$("#assignSubmit").click(function(){
		var toSend = $("#assignPlayersSelect").serialize() ;
		toSend = toSend + "&i=" + $("#routineSelect").val() ;
		$.post("setRoutineInfo.php",toSend,function(data,status){
			//console.log(data);
			$("#playerSelect").append(data) ; 
		});
		clearAssignPopup() ;
	});
	//in case the UNASSIGN button is clicked
	$("#unassignRoutine").click(function()
	{	
		$("#assignPlayersSelect").removeAttr('multiple');
		$("#assignPlayersSelect").prop('name','unassign');
		$("#assignSubmit").hide() ;
		$("#unassignSubmit").show() ;
		//prepares heading
		$("#assignPopupHeading").text("Unassign \"" + $("#routineSelect option:selected").text() + "\" from the following players:") ;
		//gets names of all players for this coach
		$("#playerSelect option").each(function(){
			$("#assignPlayersSelect").append("<option value=\""+$(this).val()+"\">"+$(this).html()+"</option>") ;
		});
		$("#assignPopup").fadeIn() ;
	});
	//in case UNASSIGN is submitted
	$("#unassignSubmit").click(function(){
		var toSend = $("#assignPlayersSelect").serialize() ;
		toSend = toSend + "&i=" + $("#routineSelect").val() ;
		$.post("setRoutineInfo.php",toSend,function(data,status){
			//console.log(data);
			$("#playerSelect option").each(function(){
				if($(this).val() == data) $(this).remove() ;
			}); 
		});
		clearAssignPopup() ;
	});
	//in case DELETE is pushed
	$("#deleteRoutine").click(function()
	{
		if(confirm("Are you sure you want to delete the routine " + $("#routineSelect option:selected").text()))
		{
			var toSend = "i=" + $("#routineSelect").val()+"&delete" ;
			$.post("setRoutineInfo.php",toSend,function(data,status){
				//console.log(data);
				var removed = $("#routineSelect option:selected").val();
				//console.log("removed: " + removed) ;
				$("#routineSelect option:selected").remove() ;
				$("#routineSelect option").each(function(){
					if($(this).val() > removed)
					{
						$(this).val($(this).val() - 1) ;
						//console.log($(this).val());
					}
				}); 
				$("#routineSelect option[value='0']").prop("selected","true");
			});
		}
	});
	//in case EDIT is clicked
	$("#editRoutine").click(function()
	{
		var toSend = "i=" + $("#routineSelect").val() + "&edit" ;
		$.post("setRoutineInfo.php", toSend, function(data, status){
			//console.log(data);
			window.location.assign("customWizard.php?" + data) ;
		});
	});
});

function clearAssignPopup()
{
	$("#assignPopup").fadeOut() ;
	$("#assignPlayersSelect option").each(function(){
			$(this).remove() ;
		});
}

function disableDelete()
{
	$("#deleteRoutine").prop('disabled',true) ;
	$("#deleteRoutine").prop('title','There must be no players assigned to a routine to be able to delete') ;
	$("#deleteRoutine").addClass("inactiveButton");
	$("#deleteRoutine").removeClass("activeButton");
}

function enableDelete()
{
	$("#deleteRoutine").prop('disabled',false) ;
	$("#deleteRoutine").prop('title','') ;
	$("#deleteRoutine").addClass("activeButton");
	$("#deleteRoutine").removeClass("inactiveButton");
}