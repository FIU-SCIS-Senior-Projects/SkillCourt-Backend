<?php
error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);
?>

<?php
include_once 'includes/db_connect.php';
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
        <title>Secure Login: Log In</title>
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
	<div id="Menu">
	</div>
	<div id="Content">
            <?php if (isset($_GET['error'])) {
		echo '<p class="error">Error Logging In!</p>';
            }?>
	    <form action="includes/process_login.php" method="post" name="login_form">
		<table cellpadding="3">
		    <tr>
			<td>Username:</td><td> <input type="text" name="un" /></td>
                    </tr>
		    <tr>
			<td>Password:</td><td> <input type="password" name="pw" id="password"></td>
		    </tr>
		    <tr>
			<td><input type="radio" name="ut" value="player" checked> Player</td>
		    </tr>
		    <tr>
			<td><input type="radio" name="ut" value="coach"> Coach</td>
		    </tr>
		    <tr>
			<td /><td><input type="button" value="Login" onclick="formhash(this.form, this.form.password);" /></td>
		    </tr>
		    <tr>
			<td /><td><small>(You can log in as a guest player with username "guest" and no password)</small></td>
		    </tr>
		</table>
            </form>
	    <?php
            if (login_check($mysqli) == true) {
                echo '<p>Currently logged ' . $logged . ' as ' . htmlentities($_SESSION['usertype']) . ' ' . htmlentities($_SESSION['username']) . '.</p>';
                echo '<p>Do you want to change user? <a href="includes/logout.php">Log out</a>.</p>';
            } else {
                echo '<p>Currently logged ' . $logged . '.</p>';
                echo "<p>If you don't have a login, please <a href='register.php'>register</a></p>";
            }
	    ?>
 	    </div>

	<div id="Footer">Copyright 2015 Skillcourt</div>
    </body>
</html>
