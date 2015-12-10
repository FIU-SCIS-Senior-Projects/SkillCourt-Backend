<div class="container leContainer" id="wizardPage">
	<div class="row">
		
		<div class="col-lg-6">
			<div id="Simulator">
				<br><br><br>
				<canvas id="sketch" data-processing-sources="customWizard/customWizard.pde" width="600" height="600">
					<p>Your browser does not support the canvas tag.</p>
				</canvas>
				<noscript>
					<p>JavaScript is required to view the contents of this page.</p>
				</noscript>
			</div>
		</div>
		
		<div class="col-lg-6" id="divWizardWrapper">
			<div id="WizardOptionsWrapper" class="optionsCustom">	
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
					<?php else : ?>
						<br/>
						<div id="switchWrapper" class="text-center">
							<button id="routineSwitch" class="btn btn-success" value="Custom">Switch to <span>Default</span></button>
						</div>	
					<?php endif ?>			
				<?php endif ?>
				
				<div id="WizardOptions" class="wizardPane">
					<h1 class="whiteHeaders text-center">Custom Options</h1>
					<hr>
					<ul class="myul">
						<li>
							<select class="form-control input-sm" id="stepType" onchange="changeDescription();">
								<option name="description" value="set">Target Set</option>
								<option name="description" value="ground">Ground Target</option>
							</select>
							<br/>
							<p id="stepDescription" class="mainText">Select a group of pads to make up a target. Your pads must be adjacent and on the same wall. When the correct pads are selected, press the 'Finish Step' button.</p>
						</li>
					</ul>

					<div class="row" id="wStep5">
								
						<div class="col-xs-8 col-xs-offset-3 mainText" id="wStep6">
							<button id="stepArrowLeft" class="myButton round" onclick="prevStep();"><</button>
							Step&nbsp;
							<span id="stepNumber"></span>
							of&nbsp;
							<span id="totalSteps"></span>
							<button id="stepArrowRight" class="myButton round" onclick="nextStep();">></button>
							<button id="addStep" class="myButton round" onclick="addStep();" title="Click to add a new Step">+</button>
						</div>

						<div class="col-xs-8 col-xs-offset-3 mainText" id="wStep7">
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
				<div id="GetNameDescription" class="wizardPane">
					<h2 class="whiteHeaders text-center">Final Step!</h2>
					<hr>
					<ul class="myul">
						<li class="mainText">Give Your Routine A Name!</li>
						</br>
						<li><input id="getName" type="text"></li>
						</br></br>
						<li class="mainText">Describe Your Routine!</li>
						</br>
						<li><textarea id="getDescription"></textarea></li>
						</br></br>
						<li><div class="text-center">
							<button id="FullFinishRoutine" class="btn btn-primary btn-sm outline stepButtons">Complete!</button>
							</div>
						</li>
						<br/>
					</ul>
				</div>

				<div id="DefaultOptions" class="wizardPane">
					<h1 class="whiteHeaders text-center">Default Options</h1>
					<hr>
					<ul class="myul">
						<li id="w2Step3"><span class="whiteHeaders">Name: </span> 
							<input class="defaultInputs mainText" type="text" id="defaultName">
						</li>
						</br>
						<li id="w2Step4"><span class="whiteHeaders">Routine: </span>
							<select class="defaultInputs mainText" id="routineSelect">
								<option value="t"selected="true">Three Wall Chase</option>
								<option value="c">Chase</option>
								<option value="h">Fly</option>
								<option value="g">Home Chase</option>
								<option value="j">Home Fly</option>
								<option value="m">Ground Chase</option>
								<option value="x">X-Cue</option>
							</select>
						</li>
						</br>
						<li id="w2Step5"><span class="whiteHeaders">Play By: </span>
							<select class="defaultInputs mainText" id="playByType">
								<option value="time" selected="true">Time (minutes)</option>
								<option value="rounds">Rounds</option>
							</select>	
							<input class="defaultInputs mainText" type="number" id="playByTypeInput" min="1" max="30" value="1" class="smallInput">
						</li>
						</br>
						<li id="difficultyRadio" class="whiteHeaders">Difficulty:</br>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="mainText" type="radio" name="difficulty" value="n" checked="true">Novice<br>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="mainText" type="radio" name="difficulty" value="i">Intermediate<br>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="mainText" type="radio" name="difficulty" value="a">Advanced
							</li>
						</br>
						<li id="timedRoundsCheckbox"><span class="whiteHeaders">Play with Timed Rounds: </span>
							<input type="checkbox">
						</li>
						<li id="timedRoundInput">
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="defaultInputs mainText" id="actualTimedRoundInput" type="number" min="1" max="30" class="smallInput">
							<span class="whiteHeaders">Seconds per round</span>
						</li>
						</br>
						<li id="w2Step8"><span class="whiteHeaders">Remove Wall:</span>
						<select class="defaultInputs mainText" id="removeWallSelect">
								<option value="0" selected="true">-None-</option>
								<option value="1">North</option>
								<option value="2">East</option>
								<option value="3">South</option>
								<option value="4">West</option>
							</select>
						</li>	
						</br>
						<li id="w2Step9"><span class="whiteHeaders">Description: </span>
							<textarea id="defaultDescription"></textarea>
						</li>
						</br>
						<li id="w2Step10">
							<div class="text-center">
								<?php if(isset($_GET["default"])):?>
									<button id="FinishDefaultEdit" class="btn btn-primary btn-sm outline stepButtons">Finish Editing Routine</button>
								<?php else : ?>
									<button id="FinishDefault" class="btn btn-primary btn-sm outline stepButtons">Finish Default Routine</button>
								<?php endif ?>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>

	</div>	
</div>