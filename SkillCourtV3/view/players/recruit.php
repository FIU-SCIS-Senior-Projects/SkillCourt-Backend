<!-- Player Selection Tab -->
<div class="container" id="selPl">
	<br>
	<ul class="nav nav-pills">
	  <li role="presentation"><a href='index.php?show=players&controller=players&action=index'>See all Players</a></li>
	  <li role="presentation"><a href='index.php?show=players&controller=players&action=signed'>Players Signed</a></li>
	</ul>

	<h2 class="whiteHeaders text-center">Recruit Players!</h2> <br>

	<?php include_once('search.php') ?>

	<table class="table table-hover whiteHeaders" id="leRecruitPlayers">
		<thead>
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Username</th>
				<th>Email</th>
				<th>Position</th>
				<th>Status</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tbody>
			<?php foreach($player as $play) {?>
				<tr>
				  	<td><?php echo $play->getFirstName(); ?></td>
				  	<td><?php echo $play->getLastName(); ?></td>
				  	<td><?php echo $play->getUserName(); ?></td>
				  	<td><?php echo $play->getEmail(); ?></td>
				  	<td><?php echo $play->getPosition(); ?></td>
				  	<td>
				  		<?php echo ($play->getStatus()) ? "Signed" : "Free"; ?>
				  	</td>
				  	<td>
				  		<button class="btn btn-default" type="submit" <?php echo "value=\"" . $play->getId() . "\" " . ($play->hasCoach() ? ( $play->isCurrentUserTheCoach() ? "" : "disabled" ) : "") ?> >
							<?php echo ($play->hasCoach() ? ( $play->isCurrentUserTheCoach() ? "RELS" : "TAKEN" ) : "SIGN"); ?>
				  		</button>
				  	</td>
			 	</tr>
			<?php } ?>
		</tbody>
	</table>
</div>