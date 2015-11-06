<!-- Player Selection Tab -->
<div class="container" id="selPl">
	<br>
	<a href='index.php?show=players&controller=players&action=index'>See all Players</a>

	<h2 class="whiteHeaders text-center">Sign your players</h2> <br>

	<?php include_once('search.php') ?>

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
			<?php foreach($player as $play) { ?>
			  <tr>
			  	<td><?php echo $play->getFirstName(); ?></td>
			  	<td><?php echo $play->getLastName(); ?></td>
			  	<td><?php echo $play->getUserName(); ?></td>
			  	<td><?php echo $play->getEmail(); ?></td>
			  	<td><?php echo $play->getPosition(); ?></td>
			  	<td><?php echo $play->getStatus(); ?></td>
			  	<td><?php echo $play->getAction(); ?></td>
			  </tr>
			<?php } ?>
		</tbody>
	</table>
</div>
