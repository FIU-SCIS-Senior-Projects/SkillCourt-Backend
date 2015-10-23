<?php
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    use Parse\ParseQuery;
    
    $currentUser = ParseUser::getCurrentUser();
    $username;
    
    if ($currentUser) {
        //$username = $currentUser->getObjectId();
        //echo $currentUser->getUsername();
        $username = $currentUser->getUsername();
    } else {
        // show the signup or login page
        Header('Location:index.php');
    }

?>

<div class="container leContainer">

    <?php if ( isset($_GET["error"])) :?>
        <script>alert("Player already has a coach or user does not exist");</script>
    <?php elseif ( isset($_GET["sc"])) :?>
        <script>alert("Player Succesfully Added");</script>
    <?php endif ?>
	<div class="row">
		<div class="col-lg-8 col-lg-offset-2">
			<div id="listOfPlayersRectangle">
	            <h2 class="whiteHeaders text-center">Players</h2>

	            <div class="container" id="signPlayersRectangle">
	            	<div class="row">
		            	<div class="col-lg-4 col-lg-offset-2 skillCourtPane">
			            	<div class="form-group">
								<label for="playertoRelease" class="whiteHeaders">Search for a player to release</label>
								<select class="form-control" name="listOfPlayers" id="listOfPlayersSelect">
									<?php
				                        if ($currentUser) {
				                            $query = new ParseQuery("SignedPlayer");
				                            $query->equalTo("coach",$currentUser);
				                            $results = $query->find();
				                            for ($i = 0; $i < count($results); $i++) {
				                                $object = $results[$i];
				                                //echo $object->getObjectId();
				                                echo "<option>" .$object->get("playerUsername") . "</button>" ;
				                            }
				                        }
				                    ?>
								</select>
								<br>
				                <button class="btn btn-success btn-sm" id="releasePlayerFromCoachButton" type="button">Release Player</button>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-lg-4 col-lg-offset-2 skillCourtPane">
							<form action="./inc/signUpPlayer.php" method="POST" name="findUsername_form">
								<div class="form-group">
									<label for="searchforplayer" class="whiteHeaders">Search for a Player to Sign</label>
									<input class="form-control" type="text" id="usernamePlayersPage" name="usernamePlayersPage" required ></input>
				                    <br>
				                    <button type="submit" class="btn btn-success btn-sm" value="SIGN PLAYER" id="submitPlayerForm" >Sign Player</button>
				                    </br>
								</div>
							</form>
						</div>
					</div>


	            </div>
            </div>
        </div>
	</div>
</div>