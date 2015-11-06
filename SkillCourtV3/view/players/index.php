<!-- Player Selection Tab -->
<div class="container" id="start">
<a href='index.php?show=players&controller=players&action=show'>Sign Players</a>

	<h2 class="whiteHeaders">Existent Players</h2>

	<table class="table table-hover whiteHeaders">
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
			<?php foreach($players as $player) { ?>
			  <tr>
			  	<td><?php echo $player->getFirstName(); ?></td>
			  	<td><?php echo $player->getLastName(); ?></td>
			  	<td><?php echo $player->getUserName(); ?></td>
			  	<td><?php echo $player->getEmail(); ?></td>
			  	<td><?php echo $player->getPosition(); ?></td>
			  	<td><?php echo $player->getStatus(); ?></td>
			  	<td><?php echo $player->getAction(); ?></td>
			  </tr>
			<?php } ?>
		</tbody>
	</table>
</div>

