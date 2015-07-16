<?php
    
include_once("parseHeader.php");
    
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    use Parse\ParseQuery;
    
    $currentUser = ParseUser::getCurrentUser();
    if ($currentUser) {
        //$username = $currentUser->getObjectId();
        //echo $currentUser->getUsername();
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
        <link rel="stylesheet" href="style/Main.css" />
    </head>
    <body>
        <div id='MainData'>
            <div id="Header"> SkillCourt </div>
            <div id="User">
                <p><a href="profile.php"></a>
                <br><a href="includes/logout.php">Logout</a></p>
                <br><p><a href="index.php">Login</a></p>
            </div>
            <div id="Menu">
                <h2><a href="Main.php">Home</a></h2>
                <h2><a href="routines.php">Routines</a></h2>
            </div>
            <div id="Content">
                <h1>My Routines</h1>
                <table border="1">
                    <tr>
                        <td align="center"><b>Routine Name</b></td>
                    </tr>
                    <tr>
                        <td>
                            <select id="routineList" name="list_box_name[]" size="10">
                            <?php
                                if ($currentUser) {
                                    $query1 = new ParseQuery("AssignedRoutines");
                                    $query1->exists("user",$currentUser);
                                    $results1 = $query1->find();
                                    if (count($results1) != 0)
                                    {
                                        $query2 = new ParseQuery("CustomRoutine");
                                        $res = $results1[1]->get("customRoutine");
                                        $playerName = $currentUser->get("firstName");
                                        //echo $playerName ." has " . count($results1) . " game(s) assigned";
                                        for ($i = 0; $i < count($results1); $i++) {
                                            $res = $results1[$i]->get("customRoutine");
                                            $query2->exists("objectId",$res);
                                            $routines = $query2->find();
                                            //echo "<tr>".$result2->get("name")."</tr>";
                                        }
                                        // echo count($result2);
                                    }
                                    
                                    for ($i = 0; $i < count($routines); $i++) {
                                        echo "<option ". "value=" . $routines[$i]->get("command")  .">".$routines[$i]->get("name")."</option>";
                                    }
                                }
                            ?>
                            </select><br><br>
                        </td>
                    </tr>
                </table>
                <button onclick="foo();">Play!</button>
                <script>
                    function foo()
                    {
                        customRoutineCommand = document.getElementById("routineList").value;
                        console.log(customRoutineCommand);
                        window.location.assign("simulator.php?rc="+customRoutineCommand);
                    }
                </script>
            </div>
            <div id="Footer">Copyright 2015 SkillCourt</div>
        </div>
    </body>
</html>
