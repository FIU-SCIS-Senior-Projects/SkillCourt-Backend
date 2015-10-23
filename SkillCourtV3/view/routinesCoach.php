<?php 
	use Parse\ParseUser;
	use Parse\ParseQuery;


	//begin query for custom routines
	$query = new ParseQuery("CustomRoutine") ;
	$query->equalTo("creator" , $currentUserIndex) ;
	$_SESSION["coachRoutines"] = $query->find() ;

	$query = new ParseQuery("DefaultRoutine") ;
	$query->equalTo("creator" , $currentUserIndex) ;
	$_SESSION["defaultRoutines"] = $query->find() ;


 ?>

<div class="container leContainer">

	<div class="row">
		
		<div class="col-lg-8 col-lg-offset-2 skillCourtPane">
			<h2 class="whiteHeaders text-center">Coach Routines</h2>
			<br>
			<div class="col-lg-4" id="routinesColumn">		
				<div id="routinesBlock">
					<select class="form-control" id="routineSelect" name="routines" size="10" >
						<?php
							$crSize = count($_SESSION["coachRoutines"]) ;
							for($i = 0 ; $i < $crSize ; $i++)
							{
								$r = $_SESSION["coachRoutines"][$i] ;
								echo '<option value="'.$i.'">'.$r->get("name").'</option>';
							}
							for($i = 0 ; $i < count($_SESSION["defaultRoutines"]) ; $i++)
							{
								$r = $_SESSION["defaultRoutines"][$i] ;
								echo '<option value="'.($i + $crSize).'">'.$r->get("name").'</option>';
							}
						?>
					</select>
					<br>
					<div id="buttonsBlock">
						<div class="btn-group" role="group">
							<button class="btn btn-success btn-sm " type="button" data-toggle="modal" data-target="#assignModal">Assign</button>
							<button class="btn btn-success btn-sm " type="button" data-toggle="modal" data-target="#unassignModal">Unassign</button><br>
						</div>
						<div class="btn-group" role="group">
							<br><button class="btn btn-success btn-sm " id="editRoutine">Edit</button>
							<button class="btn btn-success btn-sm " id="deleteRoutine">Delete</button>
						</div>
					</div>
				</div>
			</div>
			
			<div class="col-lg-4" id="assignColumn">
				<div id="routinesInfoBlock">
					<div class="form-group">
						<label for="playerSelection" class="whiteHeaders" id="playerSelectPar">Assigned to: </label>
						<select class="form-control" name="playerSelect" id="playerSelect"></select>
						<label for="routineDescription" class="whiteHeaders" id="routineDescription">Routine Description: </label>
						<textarea class="form-control" id="description" readonly></textarea>
					</div>
				</div>
			</div>

			<!-- Modal Assign-->
			<div class="modal fade" id="assignModal" tabindex="-1" role="dialog" aria-labelledby="assignModalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
							<h4 class="modal-title" id="myModalLabel">Assign Routines</h4>
						</div>
						<div class="modal-body">
							<h2 for="assignpopupheading"id="assignPopupHeading">assignPopupHeading</h2>
							<select class="form-control" id="assignPlayersSelect" size=10 name="assign[]" multiple></select>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							<button type="submit" class="btn btn-success" id="assignSubmit">Assign</button>
						</div>
					</div>
				</div>
			</div>

			<!-- Modal Unassign-->
			<div class="modal fade" id="unassignModal" tabindex="-1" role="dialog" aria-labelledby="unassignModalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
							<h4 class="modal-title" id="myModalLabel">Unassign Routines</h4>
						</div>
						<div class="modal-body">
							<h2 for="unassignpopupheading"id="unassignPopupHeading">assignPopupHeading</h2>
							<select class="form-control" id="unassignPlayersSelect" size=10 name="assign[]" multiple></select>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							<button type="submit" class="btn btn-success" id="unassignSubmit">Unassign</button>
						</div>
					</div>
				</div>
			</div>
			

		</div> <!-- end of column -->
	</div>
</div>