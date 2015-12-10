<?php
    
    include_once("parseHeader.php");
    
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

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SkillCourt</title>
    <link rel="stylesheet" type="text/css" href="style/index.css">
    <script src="//www.parsecdn.com/js/parse-1.5.0.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="parse_php/parse.js"></script>
</head>
    <body>
        <?php include 'navigation_bar.php'; ?>
        <?php if($currentUser) :  ?>
        <?php include 'card.php' ?>
        <?php endif ?>
        <?php if ( isset($_GET["error"])) :?>
            <script>alert("Player already has a coach or user does not exist");</script>
        <?php elseif ( isset($_GET["sc"])) :?>
            <script>alert("Player Succesfully Added");</script>
        <?php endif ?>
        <div id="listOfPlayersRectangle" class="default_rectangle_color">
            <h2 align="center">Players</h2>
            <div id="signPlayersRectangle" class="default_rectangle_color" >
                <div>Search for a player to release</div>
                <select id="listOfPlayersSelect">
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
                <button class="round_orange_buttons" id="releasePlayerFromCoachButton" >RELEASE PLAYER</button>
            </div>
            <div id="releasePlayersRectangle" class="default_rectangle_color" >
                <div>Search for a player to sign</div>
                <form action="signup_player.php" method="POST" name="findUsername_form">
                    <input type="text" id="usernamePlayersPage" name="usernamePlayersPage" required ></input>
                    <input type="submit" class="round_orange_buttons" value="SIGN PLAYER" id="submitPlayerForm" ></input></br>
                </form>
            </div>
        </div>
    </body>
</html>
