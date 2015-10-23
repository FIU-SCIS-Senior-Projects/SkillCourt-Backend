Parse.initialize("pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF", "JO3sLj47GgaQXiX1zbdHhim5YbpbgiYy3JhYpx9w");

var currentCommand ;

	$(".scroll button").click(function(){
		$(".scroll button[value='"+ currentCommand+"']").css("background-color","black") ;
		$(this).css("background-color","orange") ;
		currentCommand = $(this).val() ;
	});

function fetchPlayers(callback)
{
	var players;
	var currentUser = Parse.User.current();
	var SignedPlayer = Parse.Object.extend("SignedPlayer");
	var query = new Parse.Query(SignedPlayer);
    query.equalTo("coach", currentUser);  // find all the user's with this email
    query.find({
		success: function(results) {
			numberofPlayers = results.length;
			callback(results, numberofPlayers);
		},
		error: function(error) {
			alert("Error: " + error.code + " " + error.message);
		}
    });
}
function getPlayer(id, callback)
{
	var player;
	var object = id;
	player = object.get('playerUsername');
	callback(player);
}
// fetchPlayers(function(players,id){
// 	for(var i =0; i < id; i++)
// 	{
// 		getPlayer(players[i], function(username){
// 			$("#assignPlayersSelect").append('<option value=' + players[i] + '>' + username + '</option>');
// 		});
// 	}
// });
// $("#playerSelect option").each(function(){
// 	var thisVal = $(this).val() ;
// 	$("#assignPlayersSelect [value='"+thisVal+"']").remove();
// });

$(document).on('ready', function(){
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
		$("#assignColumn").fadeIn(); 
		//gets info for selected routines
		$.get("./inc/getRoutineInfo.php?i=" + $("#routineSelect").val() , function(data, status)
		{
			console.log(data);
			$("#playerSelect").remove() ;
			$('#routineDescription').remove();
			$("#description").remove() ;
			$("#playerSelectPar").after(data) ;
			
			var length = $('#playerSelect').children('option').length;
			if(length == 0) { enableDelete() ;} //disabbleUnassign() ; }
			else { disableDelete() ; }//enableUnassign() ; }
		});
	});
                  
    //in case submitPlayerForm Button is clicked
    
                  
                  
	//in case the ASSIGN button is clicked - this triggers the modal 
	$('#assignModal').on('show.bs.modal', function(event)
	{
		$("#assignPlayersSelect").attr('multiple');
		$("#assignPlayersSelect").prop('name','assign[]');
		//prepares heading
		$("#assignPopupHeading").text("Assign \"" + $("#routineSelect option:selected").text() + "\" to the following players:") ;
		//gets names of all players for this coach
		var getVal = $.get("./inc/getRoutineInfo.php?assign");
		getVal.done(function(data){
			console.log(data);
			$("#assignPlayersSelect").append(data) ;
			//removes the names of players who already have the routine assigned
			$("#playerSelect option").each(function(){
				var thisVal = $(this).val() ;
				$("#assignPlayersSelect [value='"+thisVal+"']").remove();
			});
		});

		//in case ASSIGN is submitted
		$("#assignSubmit").on('click',function(){
			var toSend = $("#assignPlayersSelect").serialize() ;
			toSend = toSend + "&i=" + $("#routineSelect").val() ;
			$.post("./inc/setRoutineInfo.php",toSend,function(data,status){
				//console.log(data);
				$("#playerSelect").append(data) ; 
			});
		});
	});
	
	//When modal is hidden, clear all of its contents
	$('#assignModal').on('hidden.bs.modal', function (e) {
		$("#assignPlayersSelect option").each(function(){
			$(this).remove() ;
		});
	})
	
	//in case the UNASSIGN button is clicked - modal has been triggered
	$('#unassignModal').on('show.bs.modal', function(event)
	{	
		$("#unassignPlayersSelect").removeAttr('multiple');
		$("#unassignPlayersSelect").prop('name','unassign');

		//prepares heading
		$("#unassignPopupHeading").text("Unassign \"" + $("#routineSelect option:selected").text() + "\" from the following players:") ;
		//gets names of all players for this coach
		$("#playerSelect option").each(function(){
			$("#unassignPlayersSelect").append("<option value=\""+$(this).val()+"\">"+$(this).html()+"</option>") ;
		});
		
		//in case UNASSIGN is submitted
		$("#unassignSubmit").click(function(){
			var toSend = $("#unassignPlayersSelect").serialize() ;
			toSend = toSend + "&i=" + $("#routineSelect").val() ;
			$.post("./inc/setRoutineInfo.php",toSend,function(data,status){
				console.log(data);
				$("#playerSelect option").each(function(){
					if($(this).val() == data) $(this).remove() ;
				}); 
			});
		});
	});
	//When modal is hidden, clear all of its contents
	$('#unassignModal').on('hidden.bs.modal', function (e) {
		$("#unassignPlayersSelect option").each(function(){
			$(this).remove() ;
		});
	})
	


	//in case DELETE is pushed
	$("#deleteRoutine").click(function()
	{
		if(confirm("Are you sure you want to delete the routine " + $("#routineSelect option:selected").text()))
		{
			var toSend = "i=" + $("#routineSelect").val()+"&delete" ;
			$.post("./inc/setRoutineInfo.php",toSend,function(data,status){
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
		$.post("./inc/setRoutineInfo.php", toSend, function(data, status){
			//console.log(data);
			window.location.assign("index.php?show=wizard&" + data) ;
		});
	});
});

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