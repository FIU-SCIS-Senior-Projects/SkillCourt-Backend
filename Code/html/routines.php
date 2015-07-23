<?php
    
include_once("parseHeader.php");
    
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    use Parse\ParseQuery;
    
    $currentUser = ParseUser::getCurrentUser();
    if ($currentUser) {
        $query1 = new ParseQuery("AssignedRoutines");
        $query1->equalTo("user",$currentUser);
        //$results1 = $query1->find();
        
    } else {
        // show the signup or login page
        header('Location: index.php?error=1');
        echo 'failure' ;
    }
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Secure Login: Protected Page</title>
        <link rel="stylesheet" href="style/index.css" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="//www.parsecdn.com/js/parse-1.5.0.min.js"></script>
        <script src="parse_php/parse.js"></script>
    </head>
    <body>
        <?php include 'navigation_bar.php'; ?>
        <?php include 'card.php' ?>
        <div id="routineRectangle">
            <div id="routineRectangleHeader">Routines</div>
            <div id="playCustomRoutineRectangle">
                <h1>Custom</h1>
                    <div class="scroll">
                    <?php
                        if ($currentUser) {
                            $query1->equalTo("type","Custom");
                            $results1 = $query1->find();
                            if(count($results1) > 0){
                                for ($i = 0; $i < count($results1); $i++) {
                                    $res = $results1[$i]->get("customRoutine");
                                    $res->fetch();
                                    //echo $res->get("name");
                                    echo "<button ". "value=" . $res->get("command")  .">".$res->get("name")."</button></br>";
                                }
                            }
                        }
                        ?>
                    </div>
            </div>
            <div id="playDefaultRoutineRectangle">
                <h1>Default</h1>
                    <div class="scroll">
                    <?php
                        if ($currentUser) {
                            $query1->equalTo("type","Default");
                            $results1 = $query1->find();
                                for ($i = 0; $i < count($results1); $i++) {
                                    $res = $results1[$i]->get("defaultRoutine");
                                    $res->fetch();
                                    echo "<button ". "value=" . $res->get("command")  .">".$res->get("name")."</button></br>";
                                }
                        }
                        ?>
                    </div>
            </div>
            <button class="round_orange_buttons" id="playRoutineButton" onclick="playRoutine();">Play</button>
        </div>
    </body>
</html>
