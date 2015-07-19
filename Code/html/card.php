<?php
    
    use Parse\ParseQuery;
    
    $username = $currentUser->getUsername();
    $name = $currentUser->get('firstName') . " " . $currentUser->get('lastName');
    $position = $currentUser->get('position');
    $coach = $currentUser->get('coach');
    $coach->fetch();
    $coachFirstName = $coach->get('firstName') . " " . $coach->get('lastName');
    $query = new ParseQuery("AssignedRoutines");
    $query->equalTo("user",$currentUser);
?>

<div id="cardProfileHeader">Profile</div>
<div id="cardGroup">
    <div id="cardProfileRectangle"></div>
    <div id="profilePictureGroup">
        <div id="oval3"></div>
        <div id="bezier"></div>
    </div>
    <div id="cardFirstNameAndLastName"><?php echo $name ?></div>
    <div id="cardPosition"><?php echo $position ?></div>
    <div id="gamesPlayedRectangle"></div>
    <div id="cardGamesPlayedHeader">Games Played</div>
    <div id="cardGamesPlayed">0</div>
</div>
