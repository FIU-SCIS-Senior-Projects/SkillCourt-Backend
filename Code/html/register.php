<?php
error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);
?>

<?php
include_once 'includes/register.inc.php';
include_once 'includes/functions.php';

sec_session_start();

if (login_check($mysqli) == true) {
    $logged = 'in';
} else {
    $logged = 'out';
}
?>
<!DOCTYPE html>
<html>
    <head>
        <title>SkillCourt Register</title>
        <link rel="stylesheet" href="style/Main.css" />
        <script type="text/JavaScript" src="js/sha512.js"></script>
        <script type="text/JavaScript" src="js/forms.js"></script>
    </head>
    <body>
        <div id="MainData">
	    <div id="Header">
		SkillCourt
	    </div>

	    <div id="User">
	    </div>
	</div>
	<div id="Content">
            <!-- Registration form to be output if the POST variables are not
            set or if the registration script caused an error. -->
            <h1>Register with us</h1>
       	    <form action="/register.php" method="post" name="registration_form">
                <table style="float: left">
		    <tr><td>Username:</td> <td><input type='text' name='username' id='username' /></td> <td>May only contain digits, upper/lowercase letters and underscores.</td></tr>
                    <tr><td>Email:</td> <td><input type="text" name="email" id="email" /></td> <td>Must be in valid email format.</td></tr>
                    <tr><td>Password:</td> <td><input type="password" name="pw" id="pw"/></td> <td>Must be least 6 characters long and contain:</td></tr>
                    <tr><td>Confirm password:</td> <td><input type="password" name="confirmpwd" id="confirmpwd" /></td> <td>&nbsp;&nbsp;&nbsp;&nbsp;At least one uppercase and one lowercase letter (A..Z) (a..z)</td></tr>
	            <tr><td><input type="radio" name="ut" id="ut" value="player" checked />Player</td> <td></td> <td>&nbsp;&nbsp;&nbsp;&nbsp;At least one number (0..9)</td></tr>
	            <tr><td><input type="radio" name="ut" id="ut" value="coach" / >Coach</td></tr>
		</table>
                <input type="button" value="Register" onclick="return regformhash(this.form, this.form.username, this.form.email, this.form.pw, this.form.confirmpwd);" />

            </form>
 	</div>

	<div id="Footer">Copyright 2015 Skillcourt</div>
    </body>
</html>

