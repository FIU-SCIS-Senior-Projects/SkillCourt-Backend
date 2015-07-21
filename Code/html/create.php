<!DOCTYPE html>
<html>
    <head>
	<meta charset="UTF-8">
	<title>Secure Login: Protected Page</title>
	<link rel="stylesheet" type="text/css" href="style/index.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="parse_php/parse.js"></script>  
<script>
$(document).ready(function(){
                  $("#continueButton").click(function(){
                                   $("#createRectangle2").slideDown("slow");
                                   });
                  });
</script>
    </head>
    <body>
        <div><img src="style/images/soccer2.jpg" id="bg" alt=""></div>
        <div id="navigationBar">
            <div class="navigationButtons" id="buttonGroup">
                <button id="homeButton" onclick="location.href = 'index.php';">Home</button>
                <button id="aboutButton">About</button>
            </div>
        </div>
        <div id="text">SkillCourt</div>
            <form action="submit_new_player.php" method="POST" name="create_form">
            <div id="createRectangle">
                <p id="signUpTitle">Sign up with your email address</p>
                <div id="createUsernameHeader">Username</div>
                <input type="text" id="createUsernameInput" name="createUsernameInput" required>
                <div id="createPasswordHeader">Password</div>
                <input type="text" id="createPasswordInput" name="createPasswordInput" required>
                <div id="createEmailHeader">Email</div>
                <input type="text" id="createEmailInput" name="createEmailInput" required >
                <div id="createPositionHeader">Position</div>
                <select id="createPositionInput" name="createPositionInput" required>
                    <option value="midfielder">Midfielder</option>
                    <option value="goalkeeper">Goalkeeper</option>
                    <option value="defender">Defender</option>
                    <option value="coach" style="display: none;">Coach</option>
                </select>
            </div>
            <div id="createRectangle2">
                <div id="createFirstNameHeader">First Name</div>
                <input type="text" id="createFirstNameInput" name="createFirstNameInput" required >
                <div id="createMiddleNameHeader">Middle Name</div>
                <input type="text" id="createMiddleNameInput" name="createMiddleNameInput" >
                <div id="createLastNameHeader">Last Name</div>
                <input type="text" id="createLastNameInput" name="createLastNameInput" required >
                <div id="createPhoneHeader">Phone</div>
                <input type="text" id="createPhoneInput" name="createPhoneInput" required >
                <div id="createBirthdateHeader">Birthdate</div>
                <input type="date" id="createBirthdateInput" name="createBirthdateInput" required >
                <div id="createGenderHeader">Gender</div>
                <select id="createGenderInput" name="createGenderInput" >
                    <option>Male</option>
                    <option>Female</option>
                </select>
                <div id="createCoachHeader">Coach</div>
                <input  type="checkbox" id="createCoachInput" name="createCoachInput" onclick="disableCoach()" >
            </div>
            <div><input type="submit" id="createPlayerButton" value="SAVE" name="Submit" ><br></div>
            </form>
        <div id="rectangle"></div>
        <div id="panel"></div>
        <div><button id="continueButton">Continue</button></div>
        <div id="pageFooter"></div>
    </body>
</html>
