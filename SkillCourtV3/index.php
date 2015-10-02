<?php
    include_once("inc/parseHeader.php");

	use Parse\ParseUser;
	use Parse\ParseObject;
	use Parse\ParseException;
    
	$currentUserIndex = ParseUser::getCurrentUser();
	$username = $firstName = $lastName = '';
    $userNotLogged = false;

    if($currentUserIndex){
        //There is a logged in user!
        $username = $currentUserIndex->getUsername();
        $firstName = $currentUserIndex->get("firstName");
        $lastName = $currentUserIndex->get("lastName");
    }else{
        $userNotLogged = true;
    }


    $errorMessage  = "" ;
    if (isset($_GET["error"])) {
        //echo $errorMessage;
    }

    if(isset($_GET['show']))
    {
        $page = $_GET['show'];

        switch ($page) {
            case 'home':
                echo "<script type=\"text/javascript\">
                alert('Youre in HOME');
                </script>";
                break;
            case 'about':
                echo "<script type=\"text/javascript\">
                alert('Youre in ABOUT');
                </script>"; 
                break;
            case 'help':
                echo "<script type=\"text/javascript\">
                alert('Youre in HELP');
                </script>";
                break;
            case 'routinesCoach':
                echo "<script type=\"text/javascript\">
                alert('Youre in routinesCoach');
                </script>";
                break;
            case 'wizards':
                echo "<script type=\"text/javascript\">
                alert('Youre in wizards');
                </script>";
                break;
            case 'players':
                echo "<script type=\"text/javascript\">
                alert('Youre in players');
                </script>";
                break;
            case 'routinesPlayer':
                echo "<script type=\"text/javascript\">
                alert('Youre in routinesPlayer');
                </script>";
                break;
            case 'simulator':
                echo "<script type=\"text/javascript\">
                alert('Youre in simulator');
                </script>";
                break;
            case 'profile':
                echo "<script type=\"text/javascript\">
                alert('Youre in profile');
                </script>";
                break;
            default:
                echo "Somewhere else";
                break;
        }
    }
    

	$pageTitle = "SkillCourt";
	include('html/head.php');
	include('html/body.php');
	include('html/footer.php'); 
?>