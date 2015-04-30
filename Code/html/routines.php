<?php
include_once 'includes/db_connect.php';
include_once 'includes/functions.php';

sec_session_start();
?>
<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
	<title>Secure Login: Protected Page</title>
	<link rel="stylesheet" href="style/Main.css" />
    </head>
    <body>
	<div id='MainData'>
	    <div id="Header">
		SkillCourt
	    </div>

	    <div id="User">
		<?php if (login_check($mysqli) == true) : ?>
		    <p><a href="profile.php"><?php echo htmlentities($_SESSION['username']); ?></a>
		    <br><a href="includes/logout.php">Logout</a></p>
		<?php else : ?>
		    <br><p><a href="index.php">Login</a></p>
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
		<?php if (isset($_GET['create'])) {
			if ($_GET['create'] == "success") {
			    echo "<p>Successfully created routine!</p>";
			}
		     }
		?>
		<?php if (login_check($mysqli) == true) : ?>
		    <h1>My Routines</h1>
		    <tr><td><input type="button" onclick="location.href = 'create.php';" value="Create New" /></td></tr>
		    <table border="1">
			<tr><td align="center"><b>Routine Name</b></td><td align="center"><b>Routine Type</b></td></tr>
			<?php echo getMyRoutines($mysqli); ?>
		    </table>
		<?php else : ?>
		    <p><span class="error">You are not authorized to access this page.</span> Please <a href="index.php">login</a></p>
		<?php endif; ?>
	    </div>
            <div id="Footer">Copyright 2015 SkillCourt</div>

        </div>
    </body>
</html>
