Parse.initialize("pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF", "JO3sLj47GgaQXiX1zbdHhim5YbpbgiYy3JhYpx9w");

// var currentCommand ;

// 	$(".scroll button").click(function(){
// 		$(".scroll button[value='"+ currentCommand+"']").css("background-color","black") ;
// 		$(this).css("background-color","orange") ;
// 		currentCommand = $(this).val() ;
// 	});

//Not being used. 
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
//Not being used
function getPlayer(id, callback)
{
	var player;
	var object = id;
	player = object.get('playerUsername');
	callback(player);
}

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
			getRoutines();
	});

	function getRoutines(){
		var selectValue = $("#routineSelect").val();
		var value = JSON.parse( selectValue );
	    var id = value['id'];
	    var type = value['type'];
	    
		var ajaxurl = './inc/routineInfo.php';
		data = {'id'   : id,
				'type' : type};
		$.post(
				ajaxurl,
				data,
				function(data, status){
					console.log(data);
					$("#playerSelect").remove();
					$('#routineDescription').remove();
					$("#description").remove() ;
					$("#playerSelectPar").after(data) ;
					
					var length = $('#playerSelect').children('option').length;
					if(length == 0) { enableDelete() ;} //disabbleUnassign() ; }
					else { disableDelete() ; }//enableUnassign() ; }
				});
	}
                         
	//in case the ASSIGN button is clicked - this triggers the modal 
	$('#assignModal').on('show.bs.modal', function(event)
	{
		$("#assignPopupHeading").text("Assign \"" + $("#routineSelect option:selected").text() + "\" to the following players:") ;

		$("#assignPlayersSelect").attr('multiple');
		$("#assignPlayersSelect").prop('name','assign[]');
		//prepares heading
		//gets names of all players for this coach
		var getVal = $.get("./inc/routineInfo.php?assign");
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
			var userSelected = $("#assignPlayersSelect").val() ;
			var routineSelect = $("#routineSelect").val();
			var value = JSON.parse( routineSelect );
		    var routineId = value['id'];
		    var routineType = value['type'];
			var ajaxurl = './inc/setRoutineInfo.php';
			data = {'routineId'   : routineId,
					'routineType' : routineType,
					'userSelected': userSelected[0],
					'assign'	  : true};

			$.when($.post(
						ajaxurl,
						data
					)
					.done(function(data){
						console.log(data);
					}))
					.then(function(data){
						closeModalAssign(data);
					});
		});
	});

	function closeModalAssign(data){
		if(data == 'true'){
			//Close modal
			$('#assignModal').modal('hide');
			getRoutines();
		}
	}
	
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
			var userSelected = $("#unassignPlayersSelect").val() ;
			var routineSelect = $("#routineSelect").val();
			var value = JSON.parse( routineSelect );
		    var routineId = value['id'];
		    var routineType = value['type'];
			var ajaxurl = './inc/setRoutineInfo.php';
			data = {'routineId'   : routineId,
					'routineType' : routineType,
					'userSelected': userSelected,
					'unassign'	  : true};

			$.when($.post(
						ajaxurl,
						data
					)
					.done(function(data){
						console.log(data);
					}))
					.then(function(data){
						closeModalunAssign(data);
					});
		});
	});
	function closeModalunAssign(data){
		if(data == 'true'){
			//Close modal
			$('#unassignModal').modal('hide');
			getRoutines();
		}
	}

	//When modal is hidden, clear all of its contents
	$('#unassignModal').on('hidden.bs.modal', function (e) {
		$("#unassignPlayersSelect option").each(function(){
			$(this).remove() ;
		});
	})
	


	//in case DELETE is clicked
	$("#deleteRoutine").click(function()
	{
		if(confirm("Are you sure you want to delete the routine " + $("#routineSelect option:selected").text()))
		{
			var routineSelect = $("#routineSelect").val();
			var value = JSON.parse( routineSelect );
		    var routineId = value['id'];
		    var routineType = value['type'];
			var ajaxurl = './inc/setRoutineInfo.php';
			data = {'routineId'   : routineId,
					'routineType' : routineType,
					'delete'	  : true};

			$.post(
					ajaxurl,
					data,
					function(data, status){

						console.log(data);
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
		var routineSelect = $("#routineSelect").val();
		var value = JSON.parse( routineSelect );
	    var routineId = value['id'];
	    var routineType = value['type'];
		var ajaxurl = './inc/setRoutineInfo.php';
		data = {'routineId'   : routineId,
				'routineType' : routineType,
				'edit'	  	  : true};

		$.post(
				ajaxurl,
				data,
				function(data, status){
					assignRoutine(data);
				});
		// var toSend = "i=" + $("#routineSelect").val() + "&edit" ;
		// $.post("./inc/setRoutineInfo.php", toSend, function(data, status){
		// 	console.log(data);
		// 	console.log(toSend);
		// 	window.location.assign("index.php?show=wizard&" + data) ;
		// });
	});

	//Get values to be editted
	function assignRoutine(data){
		window.location.assign("index.php?show=wizard&" + data) ;
	}

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