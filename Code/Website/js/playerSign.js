$(document).ready(function(){

	$('#leRecruitPlayers').on('click', 'button', function(e){
		var clickBtnValue = $(this).val();
		var ajaxurl = './inc/playerAction.php';
		data = {'action': clickBtnValue};
		$.post(
				ajaxurl, 
				data, 
				function(data,status){
					console.log("ID: " + data +  " Status: " + status);
					window.location.reload();
		});
	});
});