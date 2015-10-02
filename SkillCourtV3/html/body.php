<?php
if($userNotLogged)
{
	echo "
	<div class=\"container contBorders\">
		<div class=\"row\">
			<div class=\"col-md-12 text-center\" >
				
				<h2 class=\"modifyText\">Place holder for FRAME!!</h2>
				<!-- Frame goes here -->
				<img class=\"img-responsive center-block\" src=\"./img/stadium.jpg\">

			</div>
		</div>
	</div>

	<br/>

	<div class=\"container contBorders modifyText\">
		<div class=\"row\">
			<div class=\"col-md-12 text-center\">
				<h1>USER MODES</h1>
			</div>
		</div>

		<div class=\"row\">
			<div class=\"col-md-6\">
				<h1 class=\"text-center\">Coach Mode</h1>
				<!-- Description of Coach Mode -->
			</div>
			<div class=\"col-md-6\">
				<h1 class=\"text-center\">Player Mode</h1>
				<!-- Description of Player Mode -->
			</div>
		</div>
	</div>
	";
}
else
{
	include_once './view/profile.php';
}