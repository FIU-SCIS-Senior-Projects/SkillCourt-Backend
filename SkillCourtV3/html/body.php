<?php
if($userNotLogged)
{
	if(isset($_GET['show']))
    {
        $page = $_GET['show'];
        switch ($page) {
            case 'about':
                 //about.php
                include_once './view/about.php';
                break;
            }
    }else {
        include_once './view/home.php';
    }
}
else
{
    
	if(isset($_GET['show']))
    {
        $page = $_GET['show'];

        switch ($page) {
            case 'home':
                //Index page
            include_once './view/home.php';
                break;
            case 'about':
                 //about.php
            	include_once './view/about.php';
                break;
            case 'help':
                //help.php
            	include_once './view/help.php';
                break;
            case 'routinesCoach':
                //routinesCoach.php
                //Set variables for MVC section
                if(isset($_GET['controller']) && isset($_GET['action']))
                {
                    $controller = $_GET['controller'];
                    $action     = $_GET['action'];
                }else{
                    $controller = 'pages';
                    $action     = 'routinesHome';
                }
            	include_once './view/routinesCoach.php';
                break;
            case 'wizard':
                //wizard.php
            	include_once './view/wizard.php';
                break;
            case 'players':
                //players.php
                //Set variables for MVC section
                if(isset($_GET['controller']) && isset($_GET['action']))
                {
                    $controller = $_GET['controller'];
                    $action     = $_GET['action'];
                }else{
                    $controller = 'pages';
                    $action     = 'home';
                }
            	require_once './view/players.php';
                break;
            case 'routinesPlayer':
                //routinesPlayer.php
            	include_once './view/routinesPlayer.php';
                break;
            case 'simulator':
                //simulator.php
	            include_once './view/simulator.php';
                break;
            case 'profile':
                //profile.php
	            include_once './view/profile.php';
                break;
            default:
                echo "Somewhere else";
                break;
        }
    }
}