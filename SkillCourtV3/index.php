<?php
    include_once("inc/parseHeader.php");

	use Parse\ParseUser;
	use Parse\ParseObject;
	use Parse\ParseException;
    
	$currentUser = ParseUser::getCurrentUser();
	$username;

	if(!is_null($currentUser)){
		if ($currentUser) {
	    //$username = $currentUser->getObjectId();
	    //echo $currentUser->getUsername();
	    $username = $currentUser->getUsername();
		} else {
		    // show the signup or login page
		    Header('Location:./index.php');
		}
	}
	else{
		$currentUser = false;
	}



    $errorMessage  = "" ;
    
    if (isset($_GET["error"])) {
        //echo $errorMessage;
    }

	$pageTitle = "SkillCourt";
	include('html/head.php');
	include('html/body.php');
	include('html/footer.php'); 
?>