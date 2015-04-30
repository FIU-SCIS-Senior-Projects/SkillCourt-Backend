<?php
include_once 'includes/db_connect.php';
include_once 'includes/functions.php';

error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);

sec_session_start();
?>

<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
        <title>SkillCourt</title>
        <link rel="stylesheet" type="text/css" href="style/Main.css">
	<script type="text/JavaScript" href="js/profileChange.js">
	    function confirmChanges(pw, npw, npwc, coach, priv, form) {
		var ret = "";
		if (npw != "") {
		    if (npw != npwc) {
			// New Password must match password confirmation
			ret = ret + "bad npw ";
		    }
		    ret = ret + "good npw ";
		}
		if (coach != "") {
		    ret = "good coach ";
		}
		if (ret.indexOf("bad") == -1) {
		    form.submit;
		}
	</script>
    </head>
    <body>
        <div id="MainData">
            <div id="Header">SkillCourt</div>

            <div id="User">
                <?php if (login_check($mysqli) == true) : ?>
		    <br><p><a href=""><?php echo htmlentities($_SESSION['username']); ?></a>
		    <br><a href="includes/logout.php">Logout</a></p>
		<?php else : ?>
		    <?php header('Location: ./index.php'); ?>
		<?php endif; ?>
            </div>
            <div id="Menu">
                <h2><a href="Main.php">Home</a></h2>
		<?php
		    if (htmlentities($_SESSION['usertype']) == "coach")
			echo "<h2><a href='myplayers.php'>My Players</a></h2>";
		    else
			echo "<h2><a href='statistics.php'>My Stats</a></h2>";
		?>
                <h2><a href="routines.php">Routines</a></h2>
            </div>
            <div id="Content">
		    <h1>Profile:</h1>
		    <?php if ($_SESSION['usertype'] == "player") : ?>
		    <form onsubmit="">
			<table>
			    <tr><td>Current Password:</td> <td><input type="password" id="pw"></td></tr>
			    <tr><td>New Password:</td> <td><input type="password" id="npw"></td></tr>
			    <tr><td>Confirm New Password:</td> <td><input type="password" id="npwc"></td></tr>
			    <tr><td>Current coach:</td> <td align="center"><?php echo getCoach($_SESSION['username'], $mysqli); ?></td></tr>
			    <tr><td>New Coach:</td> <td><input type="text" id="coach"></td></tr>
			    <tr><td>Privacy Settings</td></tr>
			    <tr><td>Set to private:</td><td><input type="checkbox" name"private" value="P" <?php if (!checkPrivacyStatus($_SESSION['username'], $mysqli)) {echo " checked";}?>></td></tr>
			    <tr><td></td> <td align="right"><input type="button" value="Confirm Changes" onclick="confirmChanges(this.form.pw, this.form.npw, this.form.npwc, this.form.coach, this.form.private, this.form"></td></tr>
			</table>
		    </form>
		    <?php else : ?>
			<p>You're a coach</p>
		    <?php endif; ?>
	    </div>
            <div id="Footer">Copyright 2015 SkillCourt</div>
        </div>
    </body>
</html>

