<div class="container" id="leSignedPlayers">
	<br>
	<ul class="nav nav-pills">
	  <li role="presentation"><a href='index.php?show=players&controller=players&action=index'>See all Players</a></li>
	  <li role="presentation"><a href='index.php?show=players&controller=players&action=recruit'>Sign/Release Players</a></li>
	</ul>

	<h2 class="whiteHeaders">Players Signed by me</h2>

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
			<?php foreach($mySigned as $sign) { ?>
			  <tr>
			  	<td><?php echo $sign->getFirstName(); ?></td>
			  	<td><?php echo $sign->getLastName(); ?></td>
			  	<td><?php echo $sign->getUserName(); ?></td>
			  	<td><?php echo $sign->getEmail(); ?></td>
			  	<td><?php echo $sign->getPosition(); ?></td>
			  	<td><?php echo $sign->getCoach(); ?></td>
			  </tr>
			<?php } ?>
		</tbody>
	</table>

	<hr>
	<h2 class="whiteHeaders">Players Signed Globally</h2>

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
			<?php foreach($signed as $sign) { ?>
			  <tr>
			  	<td><?php echo $sign->getFirstName(); ?></td>
			  	<td><?php echo $sign->getLastName(); ?></td>
			  	<td><?php echo $sign->getUserName(); ?></td>
			  	<td><?php echo $sign->getEmail(); ?></td>
			  	<td><?php echo $sign->getPosition(); ?></td>
			  	<td><?php echo $sign->getCoach(); ?></td>
			  </tr>
			<?php } ?>
		</tbody>
	</table>
</div>