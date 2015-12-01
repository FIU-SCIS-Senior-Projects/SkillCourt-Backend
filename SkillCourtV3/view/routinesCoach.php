<div class="container leContainer">
	<br>
	<div class="row">
		<div class="col-lg-12">
			<ul class="nav nav-tabs nav-left" id="myRoutinesTab">
		    	<li id="listartpageRoutines" <?php echo ( (isset($_GET["show"]) && $_GET["show"] == "routinesCoach") && !(isset($_GET["controller"]))) ? 'class=active' : ''; ?>> <a class="topTab regLinks" href="index.php?show=routinesCoach" id="astartRoutines">Start</a></li>
		    	<li id="liRoutines"<?php echo (isset($_GET["controller"]) && $_GET["controller"] == "routines") ? 'class=active' : ''; ?>> <a class="topTab regLinks" href="index.php?show=routinesCoach&controller=routines&action=showRoutines" id="aselpl">Routines Home Page</a></li>
		  	</ul>

			<div class="tab-content">
				
				<?php require_once('routes.php'); ?>

			</div>
		</div>
	</div>
</div>

