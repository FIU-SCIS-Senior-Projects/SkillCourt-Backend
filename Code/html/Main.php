<?php

include_once 'parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;

$currentUser = ParseUser::getCurrentUser();
if ($currentUser) {
    //$username = $currentUser->getObjectId();
    echo $currentUser->getUsername();
} else {
    // show the signup or login page
    echo 'failure' ;
}

?>

<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
        <title>SkillCourt</title>
        <link rel="stylesheet" type="text/css" href="style/Main.css">
    </head>
    <body>
        <div id="MainData">
            <div id="Header"> 
                SkillCourt 
            </div>
            <div id="User">
		    <br><a href="includes/logout.php">Logout</a></p>
            </div>
            <div id="Menu">
                <h2><a href="Main.php">Home</a></h2>
                <h2><a href="routines.php">Routines</a></h2>

            </div>
            <div id="Content">
	    	<?php /*check loginnnnn*/ ?>
		    <h1>Welcome! </h1>
		    <p>
			<h3>Featuring next generation sports training and guidance, SkillCourt delivers
			a top of the line challenge to its users and offers in-depth progression
			statistics to set you on your way to mastery.</h3>
			<h2>Take your training to the next level!</h2>
		    </p>
	    </div>
            <div id="Footer">Copyright 2015 SkillCourt</div>
        </div>
    </body>
</html>
