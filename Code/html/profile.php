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
        <div id="profileGroup">
        <div id="profileRectangle"></div>
            <div id="profileBackgroundRectangle"></div>
            <div id="accountOverviewHeader">Account Overview</div></div>
            <form action="save_changes.php" method="POST" name="profile_form">
                <div id="personalInformationGroup">
                    <div id="personalInformationRectangle"></div>
                    <div id="firstNameHeader">First Name:</div>
                    <div id="birthDateHeader">Birth Date:</div>
                    <div id="middleInitialHeader">Middle Initial:</div>
                    <div id="lastNameHeader">Last Name:</div>
                    <div id="genderHeader">Gender:</div>
                    <div id="phoneNumberHeader">Phone:</div>
                    <div id="personalInformationHeader">Personal Information</div>
                    <input type="text" name="firstNameInput" id="firstNameInput" value =<?php echo $currentUser->get("firstName");  ?> disabled><br>
                    <input type="text" name="middleInitialInput" id="middleInitialInput" value =<?php echo $currentUser->get("middleInitial");  ?> disabled></br>
                    <input type="text" name="lastNameInput" id="lastNameInput" value = <?php echo $currentUser->get("lastName");  ?> disabled></br>
                    <select id ="genderInput" name ="genderInput" value=<?php echo $currentUser->get("gender");  ?> disabled></br>
                        <option value="Male" >Male</option>
                        <option value="Female" >Female</option>
                    </select>
                    <input type="tel" name="phoneInput" id="phoneInput" value=<?php echo $currentUser->get("phone");  ?> disabled></br>

<?php
    
    //$month = $currentUser->get("birthDate");
    //$dateFormatString = 'Y-m-d\TH:i:s.u';
    //$date = DateTime::createFromFormat('j-M-Y', '15-Feb-2009');
    //$date->format('Y-m-d');
    date_default_timezone_set('Europe/Madrid');
    
    $datetime = new DateTime();
    
    $str = $datetime->format(DateTime::ISO8601);
    
?>

                    <input type="date" name="birthDateInput" id="birthDateInput" value =<?php echo $str ?> disabled></br>
                </div>
                <div id="accountInformationGroup">
                    <div id="accountInformationRectangle"></div>
                    <div id="positionHeader">Position:</div>
                    <div id="usernameHeader">Username:</div>
                    <div id="passwordHeader">Password:</div>
                    <div id="emailHeader">Email:</div>
                    <div id="accountInformationHeader">Account Information</div>
                    <input type="text"     name="usernameInput" id="usernameInput" value=<?php echo $currentUser->get("username");  ?>  disabled ></br>
                    <input type="password" name="passwordInput" id="passwordInput" value="Default" disabled >Default Password</br>
                    <input type="email" name="emailInput" id="emailInput" value=<?php echo $currentUser->get("email");  ?> disabled></br>
                    <select id ="positionInput" name = "positionInput" value=<?php echo $currentUser->get("position");  ?> disabled></br>
                        <option value="Midfielder" >Midfielder</option>
                        <option value="Goalkeeper" >Goalkeeper</option>
                        <option value="Defender" >Defender</option>
                    </select>
                </div>
                <input id="submitButton" name="Submit"  type="submit" value="SAVE"/>
            </form>
        <button id="editProfileButton" onclick="enableFields(this);" >EDIT PROFILE</div>
        </div>
    </body>
</html>

