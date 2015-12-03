<?php
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    use Parse\ParseQuery;
    
    $currentUser = ParseUser::getCurrentUser();
    $username;
    
    if ($currentUser) {
        //$username = $currentUser->getObjectId();
        //echo $currentUser->getUsername();
        $username = $currentUser->getUsername();
    } else {
        // show the signup or login page
        Header('Location:index.php');
    }

?>

<div id="loader-wrapper">
	<div id="loader"></div>

	<div class="loader-section section-left"></div>
    <div class="loader-section section-right"></div>

</div>

<div class="container leContainer">
	<!-- Tabs for two sections.  -->
	<!-- Section one: Explanation of what you can do in this page (Players) -->
	<!-- Section two: Is where you are able to pick your players/ release them -->
	<div class="row">
		<div class="col-lg-12">
			<ul class="nav nav-tabs nav-left" id="myPlayerTab">
		    	<li id="listartpage" <?php echo ( (isset($_GET["show"]) && $_GET["show"] == "players") && !(isset($_GET["controller"]))) ? 'class=active' : ''; ?>> <a class="topTab regLinks" href="index.php?show=players" id="astart">Start</a></li>
		    	<li id="liplayers"<?php echo (isset($_GET["controller"]) && $_GET["controller"] == "players") ? 'class=active' : ''; ?>> <a class="topTab regLinks" href="index.php?show=players&controller=players&action=index" id="aselpl">Select Players</a></li>
		  	</ul>

			<div class="tab-content">
				
				<?php require_once('routes.php'); ?>

			</div>
		</div>
	</div>

    
</div>


