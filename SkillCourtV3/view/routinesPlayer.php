<?php
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    use Parse\ParseQuery;
    
    $currentUser = ParseUser::getCurrentUser();
    $query1 = new ParseQuery("AssignedRoutines");
    $query1->equalTo("user",$currentUser);
?>

<div class="container leContainer">
	<div class="row">
		<div class="col-lg-8 col-lg-offset-2">
			<div class="whiteHeaders skillCourtPane text-center">
				<h2>Routines</h2>
				<p>This list contains your current Routines!</p>
				<p>Your coach has assigned to you Custom and/or Default Routines. Go ahead and pick either one and start playing!</p>
				<br>
			</div>
			<div class="row">
				<div class="col-lg-6">
					<div id="playCustomRoutineRectangle">
		                <h1 class="whiteHeaders text-center">Custom</h1>
		                    <div class="scroll centerBlock">
		                    <?php
		                        if ($currentUser) {
		                            $query1->equalTo("type","Custom");
		                            $results1 = $query1->find();
		                            if(count($results1) > 0){
		                                for ($i = 0; $i < count($results1); $i++) {
		                                    $res = $results1[$i]->get("customRoutine");
		                                    $res->fetch();
		                                    //echo $res->get("name");
		                                    echo "<button class='btn btn-success btn-outline'". "value=" . $res->get("command")  .">".$res->get("name")."</button></br>";
		                                }
		                            }
		                        }
		                        ?>
		                    </div>
		            </div>
				</div>

				<div class="col-lg-6">
					<div id="playDefaultRoutineRectangle">
		                <h1 class="whiteHeaders text-center">Default</h1>
		                    <div class="scroll centerBlock">
		                    <?php
		                        if ($currentUser) {
		                            $query1->equalTo("type","Default");
		                            $results1 = $query1->find();
		                                for ($i = 0; $i < count($results1); $i++) {
		                                    $res = $results1[$i]->get("defaultRoutine");
		                                    $res->fetch();
		                                    echo "<button class='btn btn-success btn-outline'". "value=" . $res->get("command")  .">".$res->get("name")."</button></br>";
		                                }
		                        }
		                        ?>
		                    </div>
		            </div>
				</div>	
			</div>
			<hr>
			<div class="row">
				<div class="col-lg-2 col-lg-offset-5">
					<br><button class="btn btn-success btn-lg" id="playRoutineButton" onclick="playRoutine();">Play</button>
				</div>
			</div>
			
		</div>
	</div>
</div>
