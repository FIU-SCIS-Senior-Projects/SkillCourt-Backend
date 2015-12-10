<!-- Previous wizard class.. -->
<!-- This is obsolete -->

<div class="container leContainer">
	<div class="row">
		
		<div class="col-lg-6 wizardCol" id="simulatorColumn">
			<div id="Simulator">
				<!-- Here is the simulator -->
				<br><br><br>
				<canvas id="sketch" data-processing-sources="./customWizard/customWizard.pde" width="600" height="600">
					<p>Your browser does not support the canvas tag.</p>
				</canvas>
				<noscript>
					<p>JavaScript is required to view the contents of this page.</p>
				</noscript>
			</div>
		</div> <!-- End of col-lg-6 -->
		
		<?php if (isset($_GET["default"])) : ?>
			<script>
				defaultToEdit = <?php echo '"'.$_GET["default"].'"' ; ?> ;
				routineId = <?php echo '"'.$_GET["routine"].'"';?> ;
				defaultLock() ;
			</script>
		<?php else : ?>
			<?php if(isset($_GET["custom"])) :?>
				<script>
					commandToEdit = <?php echo '"'.$_GET["custom"].'"' ; ?> ;
					routineId = <?php echo '"'.$_GET["routine"].'"';?> ;
					//customLock() ;
				</script>
			<?php endif ?>			
		<?php endif ?>
		
		<!-- This div deals with the Give the routine a name, done after clicking finish -->
		<div class="col-lg-8 wizardPane" id="GetNameDescription">
			<form>
				<div class="form-group">
					<label for="nameCustomWizard" class="whiteHeaders">Give your routine a Name! </label>
					<input type="text" class="form-control input-sm defaultInputs" id="getName" placeholder="Routine Name" maxlength="15" required>
				</div>
				<div class="form-group">
					<label for="nameCustomWizard" class="whiteHeaders">Describe your new Custom Routine: </label>
					<textarea class="form-control" id="getDescription" rows="2" required></textarea>
					<br>
				</div>
				<button id="FullFinishRoutine" class="btn btn-primary btn-sm outline" type="submit">Complete</button>
				<button id="cancelRoutine" class="btn btn-primary btn-sm outline" type="button">Cancel</button>
			</form>
		</div>
		
		<div class="col-lg-6 wizardCol" id="optionsColumn">
			<ul class="nav nav-pills navbar-right wizardLinks" id="wizardTab">
        		<li class="active" id="liCustOptions"><a href="#customOptions" data-toggle="tab" id="acustomopt">Custom Options</a></li>
            	<li id="liDefaultOptions"><a href="#defaultOpts" data-toggle="tab" id="adefaultopt">Default Options</a></li>
          	</ul>
            
          	<div class="tab-content">
            	<br>

            	<div class="tab-pane active mainText" id="customOptions">
            	<!-- Custom Options Pane  -->
              		<div class="wizardPane center-block">

						<h2 class="wizardHeaders text-center">Custom Options</h2>
							<div class="row">
								<div class="col-xs-4 col-xs-offset-4">
								<br>
									<div class="form-group" id="wStep3">
										<select class="form-control input-sm" id="stepType" onchange="changeDescription();">
											<option name="description" value="set">Target Set</option>
											<option name="description" value="ground">Ground Target</option>
										</select>
									</div>
								</div>
								<div class="col-xs-12 text-center">
									<p id="stepDescription">Select a group of pads to make up a target. Your pads must be adjacent and on the same wall. When the correct pads are selected, press the 'Finish Step' button.</p>						
								</div>
							</div>
							
							<div class="row" id="wStep5">
								
								<div class="col-xs-8 col-xs-offset-3" id="wStep6">
									<button id="stepArrowLeft" class="myButton round" onclick="prevStep();"><</button>
									Step&nbsp;
									<span id="stepNumber"></span>
									of&nbsp;
									<span id="totalSteps"></span>
									<button id="stepArrowRight" class="myButton round" onclick="nextStep();">></button>
									<button id="addStep" class="myButton round" onclick="addStep();" title="Click to add a new Step">+</button>
								</div>

								<div class="col-xs-8 col-xs-offset-3" id="wStep7">
									<button id="roundArrowLeft" class="myButton round" onclick="prevRound();"><</button>
									Round&nbsp;
									<span id="roundNumber"></span>
									of&nbsp;
									<span id="totalRounds"></span>
									<button id="roundArrowRight" class="myButton round" onclick="nextRound();">></button>
									<button id="addRound" class=" myButton round" onclick="addRound();" title="Click to add a new Round">+</button>
								</div>
							</div>

							<div class="row">
								<div class="col-xs-8 col-xs-offset-3">
									<br>
									<div class="btn-group" role="group" id="wStep8">
										<button id="DeleteStep"  class="btn btn-primary btn-sm outline delButtons" onclick="deleteStep();">Delete Step</button>
										<button id="DeleteRound" class="btn btn-primary btn-sm outline delButtons" onclick="deleteRound();">Delete Round</button>
									</div>
								</div>

								<div class="col-xs-6 col-xs-offset-3">
										<button id="EditStep"   class="btn btn-primary btn-sm outline stepButtons" onclick="editStep();">Edit Step</button>
								</div>
								<div class="col-xs-6 col-xs-offset-3">
										<button id="FinishStep" class="btn btn-primary btn-sm outline stepButtons" onclick="finishStep();">Finish Step</button>
								</div>
																

								<div class="col-xs-6 col-xs-offset-3">
									<?php if(isset($_GET["custom"])):?>
										<button id="FinishCustomEdit" class="btn btn-primary btn-sm outline stepButtons" onclick="finishEdit();">Finish Editing Routine</button>
									<?php else : ?>
										<button id="FinishRoutineButton" class="btn btn-primary btn-sm outline stepButtons" onclick="finishRoutine();">Finish Custom Routine</button>
									<?php endif ?>
								</div>

								<div class="col-xs-12 text-center le" id="Warning">
								</div>

							</div>	
              		</div>
             	</div><!--/tab-pane-->
	            


	            <div class="tab-pane" id="defaultOpts">
               	<!-- Default Options Pane -->
               		<div class="wizardPane center-block">
              			
						<h2 class="wizardHeaders text-center">Default Options</h2>
						<br>
						<div class="row">
							<div class="col-xs-8 col-xs-offset-3">
								<form class="form-inline">
									<div class="form-group">
										<label for="nameDefaultWizard" class="whiteHeaders">Name: </label>
										<input type="text" class="form-control input-sm defaultInputs mainText" id="defaultName" placeholder="Routine Name" maxlength="15" required>
									</div>
								</form>
							</div>

							<div class="col-xs-8 col-xs-offset-3">
								<form class="form-inline">
									<div class="form-group">
										<label for="nameDefaultWizard" class="whiteHeaders">Routine: </label>
										<select class="form-control input-sm defaultInputs mainText" id="routineSelect">
											<option value="" selected="true"></option>
											<option value="t">Three Wall Chase</option>
											<option value="c">Chase</option>
											<option value="h">Fly</option>
											<option value="g">Home Chase</option>
											<option value="j">Home Fly</option>
											<option value="m">Ground Chase</option>
											<option value="x">X-Cue</option>
										</select>
									</div>
								</form>
							</div>

							<div class="col-xs-8 col-xs-offset-3">
								<form class="form-inline">
									<div class="form-group">
										<label for="nameDefaultWizard" class="whiteHeaders">Play By: </label>
										<select class="form-control input-sm defaultInputs mainText" id="playByType">
											<option value="time" selected="true">Time (minutes)</option>
											<option value="rounds">Rounds</option>
										</select>	
										<input class="form-control input-sm defaultInputs mainText" type="number" id="playByTypeInput" min="1" max="30" value="1">
									</div>
								</form>
							</div>

							<div class="col-xs-8 col-xs-offset-3 mainText" id="difficultyRadio">
								<label for="difficulty" class="whiteHeaders">Difficulty</label>
								<div class="radio">
									<label>
										<input class="defaultInputs" type="radio" name="difficulty" value="n" checked>
										Novice
									</label>
								</div>
								<div class="radio">
									<label>
										<input type="radio" name="difficulty" value="i">
										Intermediate
									</label>
								</div>
								<div class="radio">
									<label>
										<input type="radio" name="difficulty" value="a">
										Advanced
									</label>
								</div>							
							</div>

							<div class="col-xs-8 col-xs-offset-3 mainText">
								<div id="timedRoundsCheckbox">
									<label class="checkbox-inline">
										<input type="checkbox" value="">
										Play with Timed Rounds
									</label>
								</div>
							</div>

							<div class="col-xs-8 col-xs-offset-3 mainText">
								<form class="form-inline">
									<div class="form-group" id="timedRoundInput">
										<input class="form-control input-sm defaultInputs mainText" id="actualTimedRoundInput" type="number" min="1" max="30">
										Seconds per Round
									</div>
								</form>
							</div>

							<div class="col-xs-8 col-xs-offset-3">
								<form class="form-inline">
									<div class="form-group">
										<label for="nameDefaultWizard" class="whiteHeaders">Remove Wall: </label>
										<select class="form-control input-sm defaultInputs mainText" id="removeWallSelect">
											<option value="0" selected="true">-None-</option>
											<option value="1">North</option>
											<option value="2">East</option>
											<option value="3">South</option>
											<option value="4">West</option>
										</select>
									</div>
								</form>
							</div>

							<div class="col-xs-8 col-xs-offset-3">
								<div>
									<label class="whiteHeaders">Description:</label>
									<textarea id="defaultDescription" rows="2" class="form-control"></textarea>
								</div>
							</div>

							<div class="col-xs-6 col-xs-offset-3">
							<br>
								<?php if(isset($_GET["default"])):?>
									<button id="FinishDefaultEdit" class="btn btn-primary btn-sm outline stepButtons">Finish Editing Routine</button>
								<?php else : ?>
									<button id="FinishDefault" class="btn btn-primary btn-sm outline stepButtons">Finish Default Routine</button>
								<?php endif ?>
							</div>

						</div> <!-- end of row -->
              		</div>
               		
             	</div><!--/tab-pane-->


			</div> <!-- Tab Content div -->

		</div> <!-- End of col-lg-6 -->
	

	</div> <!-- End of row -->
</div> <!-- End of container -->
