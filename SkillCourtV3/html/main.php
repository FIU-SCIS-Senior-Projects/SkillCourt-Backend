<?php

include_once("../inc/parseHeader.php");

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
        <?php include '../inc/headerCode.php'; ?>
    </head>
    <body>
        <?php include '../inc/navbar.php'; ?>
        <?php if($currentUser) :  ?>
        <?php include 'card.php' ?>
        <?php endif ?>
        <?php include '../html/footer.php'; ?>
    </body>
</html>
