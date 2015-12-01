<title><?php echo $pageTitle; ?></title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="description" content="Soccer Training - SkillCourt">
<meta name="author" content="Will Rodriguez, Sergio Saucedo">

<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="./js/bootstrap.min.js"></script>

<!-- Parse CDN -->
<script src="//www.parsecdn.com/js/parse-1.6.4.min.js"></script>

<!-- Custom Javascrip Files -->
<script type="text/javascript" src="./js/signUpFunctions.js"></script>
<script type="text/javascript" src="./js/registrationFunctions.js"></script>

<!-- Processing Javascript files -->
<?php if(isset($_GET['show']) && $_GET['show'] == 'wizard' ) : ?>
<script type="text/javascript" src="./js/processing.js" ></script>
<script type="text/javascript" src="./js/wizardFunctionsjQuery.js"></script>
<script type="text/javascript" src="./js/wizardFunctions.js"></script>
<?php endif ?>

<!-- Routines Coach Javascript files -->
<?php if( isset($_GET['show']) && $_GET['show'] == 'routinesCoach' ) : ?>
<script type="text/javascript" src="./js/coachRoutines.js"></script>
<?php endif ?>

<!-- Simulator Javascript files -->
<?php if(isset($_GET['show']) && $_GET['show'] == 'simulator' ) : ?>
<meta name="Generator" content="Processing" />
<script type="text/javascript" src="./js/processing.js" ></script>
<script type="text/javascript" src="./js/buzz.min.js"></script>
<script type="text/javascript" src="./js/simulator.js"></script>
<?php endif ?>

<!-- Routines Player  -->
<?php if(isset($_GET['show']) && $_GET['show'] == 'routinesPlayer' ) : ?>
<script type="text/javascript" src="./js/simulatorPlay.js"></script>
<?php endif ?>

<!-- Bootstrap Core CSS -->
<link href="./css/bootstrap.min.css" rel="stylesheet" type="text/css">

<!-- Custom CSS -->
<link href="./css/skillcourt.css" rel="stylesheet" type="text/css">
<link href="./css/sticky.css" rel="stylesheet" type="text/css">
<link href="./css/wizard.css" rel="stylesheet" type="text/css">

<!-- Custom Fonts -->
<link href="./font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

<!-- Custom Javascript for Interactive Summary Table -->
<script type="text/javascript" src="./js/jquery.cycle.all.2.74.js"></script>
<script type="text/javascript" src="./js/globalScripts.js"></script>

<!-- bxSlider Javascript file -->
<script src="./js/jquery.bxslider/jquery.bxslider.min.js"></script>
<!-- bxSlider CSS file -->
<link href="./css/jquery.bxslider.css" rel="stylesheet" />

<!-- intro.js CSS file -->
<link href="./js/intro.js/introjs.css" rel="stylesheet" type="text/css">

<!-- intro.js Javascript file -->
<script src="./js/intro.js/intro.js"></script>

<!-- Recruit/Release Player Scripts -->
<?php if(isset($_GET['show']) && $_GET['show'] == 'players' ) : ?>
<script type="text/javascript" src="./js/playerSign.js" ></script>
<?php endif ?>

