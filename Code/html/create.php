<?php
include_once 'includes/functions.php';
include_once 'includes/create.inc.php';


sec_session_start();
?>
<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
	<title>Secure Login: Protected Page</title>
	<link rel="stylesheet" href="style/Main.css" />
	<script type="text/javascript">
	    function changeGround() {
		var ground = document.getElementById('ground')
		if (ground.checked == 1) {
		    alert("Ground targetting feature is not yet available");
		    ground.checked = false;
		}
	    }
	</script>
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
		<?php if (login_check($mysqli) == true) : ?>
				  <form action="/create.php" method="POST">
				      Select a type of routine to create: 
		    	              <select id="type" name="type" onchange="this.form.submit()">
		    		          <option value="">--
					  <option value="F">Fly Me
					  <option value="C">Chase Me
		    		          <option value="">More to come...
		    	              </select>
			          </form>
			<?php if (!isset($htm)) : ?>
			<?php else : ?>
				  <?php echo $htm; ?>
			<?php endif; ?>
		<?php else : ?>
		    <p><span class="error">You are not authorized to access this page.</span> Please <a href="index.php">login</a></p>
		<?php endif; ?>
	    </div>
            <div id="Footer">Copyright 2015 SkillCourt</div>

        </div>
    </body>
</html>
