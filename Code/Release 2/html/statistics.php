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
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<?php
	    echo "<script type='text/javascript'>
    	    google.load('visualization', '1.1', {packages: ['line']});

    	    function drawChartAcc() {
		var data = new google.visualization.DataTable();
      		data.addColumn('datetime', 'Date');
      		data.addColumn('number', '');
		data.addRows(" . getAccuracyChart($_SESSION['username'], $mysqli) . ");

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
      		data.addRows(" . getForceChart($_SESSION['username'], $mysqli) . ");

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
	<div id="fb-root"></div>
	<script>
	    (function(d, s, id) {
  		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.3&appId=304568816231285";
		fjs.parentNode.insertBefore(js, fjs);
	    }(document, 'script', 'facebook-jssdk'));
	</script>
        <div id="MainData">
            <div id="Header">SkillCourt</div>

            <div id="User">
                <?php if (login_check($mysqli) == true) : ?>
		    <br><p><a href="profile.php"><?php echo htmlentities($_SESSION['username']); ?></a>
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
		<h1>My Statistics:</h1>
		<p>Select a statistic below to view your performance.</p>
		<input type="button" value="Force" onclick="drawChartForce()" />
		<input type="button" value="Accuracy" onclick="drawChartAcc()" />
		<div id="linechart_material"></div>
		<div class="fb-share-button" data-href=<?php echo "'http://skillcourt-dev.cis.fiu.edu/player.php?player=" . $_SESSION['username'] . "'"; ?> data-layout="button"></div>
	    </div>
            <div id="Footer">Copyright 2015 SkillCourt</div>
        </div>
    </body>
</html>

