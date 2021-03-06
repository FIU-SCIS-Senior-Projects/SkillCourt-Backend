<?php
include_once 'includes/db_connect.php';
include_once 'includes/functions.php';

error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);

sec_session_start();
$canView = false;
?>
<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
        <title>SkillCourt</title>
        <link rel="stylesheet" type="text/css" href="style/Main.css">
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<?php echo "<script type='text/javascript'>
	    google.load('visualization', '1.1', {packages: ['line']});

    	    function drawChartAcc() {
		var data = new google.visualization.DataTable();
      		data.addColumn('datetime', 'Date');
      		data.addColumn('number', '');
		data.addRows(" . getAccuracyChart($_GET['player'], $mysqli) . ");

		var options = {
        	    chart: {
          		title: 'Accuracy (%)'
		    },
        	    width: 600,
        	    height: 400
	    	};

	    	var chart = new google.charts.Line(document.getElementById('linechart_material'));

	    	chart.draw(data, options);
	    }

   	    	function drawChartForce() {
		var data = new google.visualization.DataTable();
      		data.addColumn('datetime', 'Date');
      		data.addColumn('number', '');
      		data.addRows(" . getForceChart($_GET['player'], $mysqli) . ");

		var options = {
        	    chart: {
          		title: 'Force (N)'
		    },
        	    width: 600,
        	    height: 400
	    	};

	    	var chart = new google.charts.Line(document.getElementById('linechart_material'));

	    	chart.draw(data, options);
    	    }
	</script>"; ?>
    </head>
    <body>
        <div id="MainData">
            <div id="Header">SkillCourt</div>

            <div id="User">
		<?php if (login_check($mysqli) == true) : ?>
		    <br><p><a href="profile.php"><?php echo htmlentities($_SESSION['username']); ?></a>
		    <br><a href="includes/logout.php">Logout</a></p>
		<?php else : ?>
		    <p><a href="index.php">Login</a></p>
		<?php endif; ?>
	    </div>

            <div id="Menu">
		<?php if (login_check($mysqli) == true) : ?>
            	    <h2><a href='Main.php'>Home</a></h2>
			<?php
			    if (htmlentities($_SESSION['usertype']) == "coach") {
				echo "<h2><a href='myplayers.php'>My Players</a></h2>";
			    } else {
				echo "<h2><a href='statistics.php'>My Stats</a></h2>";
			    }
			?>
		    <h2><a href='routines.php'>Routines</a></h2>
		<?php endif; ?>
            </div>

            <div id="Content">
		<?php if (isset($_GET['player'])) {
		    if (isset($_SESSION['username'])) {
			if (($_SESSION['usertype'] == "coach") && (strcasecmp(getCoach($_GET['player'], $mysqli), $_SESSION['username']) == 0)) {
			    echo "<p><h1>" . $_GET['player'] . "'s Profile</h1>Back to <a href='myplayers.php'>My Players</a></p>";
			    $canView = true;
			} elseif (checkPrivacyStatus($_GET['player'], $mysqli)) {
			    echo "<p><h1>" . $_GET['player'] . "'s Profile</h1></p>";
			    $canView = true;
			} else {
			    echo "<p>This player's profile is set to Private and cannot be viewed. </p>";
			}
		    } elseif (checkPrivacyStatus($_GET['player'], $mysqli)) {
			echo "<p><h1>" . $_GET['player'] . "'s Profile</h1></p>";
			$canView = true;
		    } else {
			echo "<p>This player's profile is set to Private and cannot be viewed. </p>";
		    }
		} else {
		    echo "<h1>OOPS!</h1>";
		    echo "<p>You've reached a page that is missing information and cannot be displayed properly.</p>";
		    echo "<p><a href='Main.php'>Click Here</a> to go back to safety.</p>";
		}
		if ($canView) {
		    echo "<table>" . playerInfo($_GET['player'], $mysqli) . "</table>";
		    echo "<input type='button' value='Force' onclick='drawChartForce()' />";
		    echo "<input type='button' value='Accuracy' onclick='drawChartAcc()' />";
		}
		?>
	        <div id="linechart_material"></div>
	    </div>
            <div id="Footer">Copyright 2015 SkillCourt</div>
        </div>
    </body>
</html>
