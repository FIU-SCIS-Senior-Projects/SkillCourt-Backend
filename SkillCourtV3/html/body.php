<?php
if($userNotLogged)
{
	if(isset($_GET['show']))
	{
		if($_GET['show'] == 'about')
		{
			//Show the about page
			include_once './view/about.php';
		}
	}
	else
	{
		//Show the index page. This page will be shown on load up. 
		echo "
		<div class=\"container contBorders\">
			<div class=\"row\">
				<div class=\"col-md-12 text-center\" >
					
					<h2 class=\"modifyText\">Place holder for FRAME!!</h2>
					<!-- Frame goes here -->
					<img class=\"img-responsive center-block\" src=\"./img/stadium.jpg\">

				</div>
			</div>
		</div>

		<br/>

		<div class=\"container contBorders modifyText\">
			<div class=\"row\">
				<div class=\"col-md-12 text-center\">
					<h1>USER MODES</h1>
				</div>
			</div>

			<div class=\"row\">
				<div class=\"col-md-6\">
					<h1 class=\"text-center\">Coach Mode</h1>
					<!-- Description of Coach Mode -->
				</div>
				<div class=\"col-md-6\">
					<h1 class=\"text-center\">Player Mode</h1>
					<!-- Description of Player Mode -->
				</div>
			</div>
		</div>
		";
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
            	include_once './view/routinesCoach.php';
                break;
            case 'wizard':
                //wizard.php
            	include_once './view/wizard.php';
                break;
            case 'players':
                //players.php
            	include_once './view/players.php';
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