<?php
    
    include_once("parseHeader.php");
    
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    
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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="//www.parsecdn.com/js/parse-1.5.0.min.js"></script>
        <script src="parse_php/parse.js"></script>
    </head>
    <body>
        <?php include 'navigation_bar.php'; ?>
        <?php include 'card.php' ?>
        <div id="profileBackgroundRectangle">
            <form action="save_changes.php" method="POST" name="profile_form">
            <h1>Account Overview</h1>
            <div id="personalInformationRectangle">
                <h1>Personal Information</h1>
                <div id="firstNameHeader">First Name:</div>
                <input type="text" name="firstNameInput" id="firstNameInput" value =<?php echo $currentUser->get("firstName");  ?> disabled><br>
                <div id="middleInitialHeader">Middle Initial:</div>
                <input type="text" name="middleInitialInput" id="middleInitialInput" value =<?php echo $currentUser->get("middleInitial");  ?> disabled></br>
                <div id="lastNameHeader">Last Name:</div>
                <input type="text" name="lastNameInput" id="lastNameInput" value = <?php echo $currentUser->get("lastName");  ?> disabled></br>
                <div id="birthDateHeader">Birth Date:</div>
                <input type="date" name="birthDateInput" id="birthDateInput" value =<?php /*echo $str*/ ?> disabled></br>
                <div id="genderHeader">Gender:</div>
                <select id ="genderInput" name ="genderInput" value=<?php echo $currentUser->get("gender");  ?> disabled></br>
                    <option value="Male" >Male</option>
                    <option value="Female" >Female</option>
                </select>
                <div id="phoneNumberHeader">Phone:</div>
                <input type="tel" name="phoneInput" id="phoneInput" value=<?php echo $currentUser->get("phone");  ?> disabled></br>
                <?php
                    
                    //$month = $currentUser->get("birthDate");
                    //$dateFormatString = 'Y-m-d\TH:i:s.u';
                    //$date = DateTime::createFromFormat('j-M-Y', '15-Feb-2009');
                    //$date->format('Y-m-d');
                    /*date_default_timezone_set('Europe/Madrid');
                    
                    $datetime = new DateTime();
                    
                    $str = $datetime->format(DateTime::ISO8601);*/
                ?>
            </div>
            <div id="accountInformationRectangle">
                <h1>Account Information</h1>
                <div id="positionHeader">Position:</div>
                <select id ="positionInput" name = "positionInput" value=<?php echo $currentUser->get("position");  ?> disabled></br>
                    <option value="Goalkeeper">Goalkeeper</option>
                    <option value="Center-Back">Center-Back</option>
                    <option value="Left-Back">Left-Back</option>
                    <option value="Right-Back">Right-Back</option>
                    <option value="Left Wing Back">Left Wing Back</option>
                    <option value="Right Wing Back">Right Wing Back</option>
                    <option value="Defending Midfielder">Defending Midfielder</option>
                    <option value="Central Midfielder">Central Midfielder</option>
                    <option value="Attacking Midfielder">Attacking Midfielder</option>
                    <option value="Left Wing">Left Wing</option>
                    <option value="Right Wing">Right Wing</option>
                    <option value="Withdrawn Striker">Withdrawn Striker</option>
                    <option value="Striker">Striker</option>
                    <option value="Coach">Coach</option>
                </select>
                <div id="usernameHeader">Username:</div>
                <input type="text"     name="usernameInput" id="usernameInput" value=<?php echo $currentUser->get("username");  ?>  disabled ></br>
                <div id="passwordHeader">Password:</div>
                <input type="password" name="passwordInput" id="passwordInput" value="Default" disabled ></br>
                <div id="emailHeader">Email:</div>
                <input type="email" name="emailInput" id="emailInput" value=<?php echo $currentUser->get("email");  ?> disabled></br>
            </div>
            <input class="round_orange_buttons" id="submitButton" name="Submit"  type="submit" value="SAVE"/>
            </form>
            <button class="round_orange_buttons" id="editProfileButton" onclick="enableFields(this);" >EDIT PROFILE</div>
        </div>
    </body>
</html>

