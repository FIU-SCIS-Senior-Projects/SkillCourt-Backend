<?php

include_once 'parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;


$errorMessage  = "" ;

if (isset($_GET["error"])) {
	$errorMessage = "Invalid Login Credentials";
}

?>

<!DOCTYPE html>
<html>
    <head>
        <title>Secure Login: Log In</title>
        <link rel="stylesheet" href="style/Main.css" />
    </head>
    <body>
        <div id="MainData">
	    <div id="Header">
		SkillCourt
	    </div>

	    <div id="User">

	    </div>
	<div id="Menu">
	</div>
	<div id="Content">
	    <form action="process_login.php" method="post" name="login_form">
		<table cellpadding="3">
		    <tr>
				<td>Username:</td><td> <input type="text" name="username" /></td>
            </tr>
		    <tr>
				<td>Password:</td><td> <input type="password" name="password" id="password"></td>
		    </tr>
		    <tr>
				<td /><td><input type="submit"/></td>
		    </tr>
		    <tr>
				<td /><td><small>(You can log in as a guest player with username "guest" and no password)</small></td>
		    </tr>
		</table>
		<p> <?php echo $errorMessage ; ?> </p>	
				
			<a class="simulator_block" href="simulator.php"> Try Simulator!</a>
            <a class="simulator_block" href="routineWizard.php"> Try Routine Wizard!</a>
            
            </form>
 	    </div>

	<div id="Footer">Copyright 2015 Skillcourt</div>
    </body>
</html>
