<?php 
include_once("parseHeader.php");
use Parse\ParseObject ;
use Parse\ParseUser;
use Parse\ParseQuery ;
use Parse\ParseException ;
session_unset(); 
ParseUser::logout() ;
Header('Location: ../html/index.php');
?>