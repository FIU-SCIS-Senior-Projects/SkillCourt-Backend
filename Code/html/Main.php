<?php

include_once("parseHeader.php");

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;

$currentUser = ParseUser::getCurrentUser();
$username;
    
if ($currentUser) {
    //$username = $currentUser->getObjectId();
    //echo $currentUser->getUsername();
    $username = $currentUser->getUsername();
} else {
    // show the signup or login page
    Header('Location:index.php');
}

?>

<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
        <title>SkillCourt</title>
        <link rel="stylesheet" type="text/css" href="style/index.css">
    </head>
    <body>
        <?php include 'navigation_bar.php'; ?>
        <?php if($currentUser) :  ?>
        <?php include 'card.php' ?>
        <?php endif ?>
    </body>
</html>
