<?php
    
    include_once("../inc/parseHeader.php");
    
    use Parse\ParseObject;
    use Parse\ParseException;
    
    $errorMessage  = "" ;
    
    if (isset($_GET["error"])) {
        //echo $errorMessage;
    }
?>

<?php 
$pageTitle = "SkillCourt";
include('head.php'); ?>

<?php include('body.php'); ?>

<?php include('footer.php'); ?>