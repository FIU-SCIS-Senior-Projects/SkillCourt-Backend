<?php
    
    use Parse\ParseQuery;
    
    $username = $currentUser->getUsername();
    $name = $currentUser->get('firstName') . " " . $currentUser->get('lastName');
    $position = $currentUser->get('position');
    $isCoach = $currentUser->get('isCoach');
    if (!$isCoach)
    {
        $query = new ParseQuery("AssignedRoutines");
        $query->equalTo("user",$currentUser);
    }
?>

<div id="welcomeProfileHeader">Welcome <?php /*echo $currentUser->get('firstName')*/ ?> </div>
<div id="cardProfileHeader">Profile</div>
<div id="cardProfileRectangle">
    <div id="cardOval"></div>
    <div id="cardFirstNameAndLastName"><?php echo $name ?></div>
    <div id="cardPosition"><?php echo $position ?></div>
    <div id="gamesPlayedRectangle">
        <div id="cardGamesPlayedHeader">Games Played</div>
        <div id="cardGamesPlayed">0</div>
    </div>
</div>
