<!-- Player Selection Tab -->
<div class="container" id="start">
	<br>
	<ul class="nav nav-pills">
	  <li role="presentation"><a href='index.php?show=players&controller=players&action=signed'>Players Signed</a></li>
	  <li role="presentation"><a href='index.php?show=players&controller=players&action=recruit'>Sign/Release Players</a></li>
	</ul>

	<h2 class="whiteHeaders">Existent Players</h2>

	<table class="table table-hover whiteHeaders">
		<thead>
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Username</th>
				<th>Email</th>
				<th>Position</th>
				<th>Coach</th>
			</tr>
		</thead>
		<tbody>
			<?php foreach($players as $player) { ?>
			  <tr>
			  	<td><?php echo $player->getFirstName(); ?></td>
			  	<td><?php echo $player->getLastName(); ?></td>
			  	<td><?php echo $player->getUserName(); ?></td>
			  	<td><?php echo $player->getEmail(); ?></td>
			  	<td><?php echo $player->getPosition(); ?></td>
			  	<td><?php echo $player->getCoach(); ?></td>
			  </tr>
			<?php } ?>
		</tbody>
	</table>
</div>

