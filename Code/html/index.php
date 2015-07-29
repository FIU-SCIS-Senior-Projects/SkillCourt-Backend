<?php
    
    include_once("parseHeader.php");
    
    use Parse\ParseObject;
    use Parse\ParseException;
    
    $errorMessage  = "" ;
    
    if (isset($_GET["error"])) {
        //echo $errorMessage;
    }
?>

<!DOCTYPE HTML>
<html>
    <head>
        <title>Secure Login: Log In</title>
        <link rel="stylesheet" href="style/index.css" />
        <meta charset="UTF-8">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="//www.parsecdn.com/js/parse-1.5.0.min.js"></script>
        <script src="parse_php/parse.js"></script>
        <script>
        $(document).ready(function(){
                          <?php if ( isset($_GET["logIn"])) :?>
                          $("#fade").fadeIn() ;
                          $(".white_content").fadeIn() ;
                          <?php endif ?>
                          
                          <?php if (isset($_GET["error"])) : ?>
                          $("#invalidLoginMessage").fadeIn() ;
                          $("#fade").fadeIn() ;
                          $(".white_content").fadeIn() ;
                          <?php endif ?>
                          
                          $("#logInButton").click(function(){
                                                  $("#fade").fadeIn() ;
                                                  $(".white_content").fadeIn() ;
                                                  });
                          $("#exitButton").click(function(){
                                                 $("#fade").fadeOut() ;
                                                 $(".white_content").fadeOut() ;
                                                 });
                          $("#exitChangePasswordButton").click(function(){
                                                 $("#fade").fadeOut() ;
                                                 $(".white_content").fadeOut() ;
                                                 });
                          
                          });

        </script>
    </head>
<body>
    <div><img src="style/images/soccer2.jpg" id="bg" alt=""></div>
    <div id="navigationBar">
        <div class="navigationButtons" id="buttonGroup">
            <button id="homeButton" onclick="location.href = 'index.php';">Home</button>
            <button id="aboutButton" onclick="location.href = 'about.php';">About</button>
        </div>
        <div id="text">SkillCourt</div>
    </div>
    <div id="registerNowZoom">
        <div id="zoomRectangle" class = "default_rectangle_color">
            <div id="zoomOval"></div>
            <button class="round_orange_buttons" onclick="location.href = 'create.php';" id="registerNowButton">REGISTER NOW</button>
            <div id="registerNowHeader">and start playing!</div>
        </div>
    </div>
    <button id="logInButton" href = "javascript:void(0)" >Log In</button>
    <div id="light" class="white_content">This is the lightbox content.
        <div id="logInRectangle">
            <div id="headerLogInRectangle">Log In or Create an Account
                <button id="exitButton"  > &#10006; </button>
            </div>
            <div>
                <form action="process_login.php" method="POST" name="login_form">
                    <input type="text" name="username" id="username" placeholder="Username" required><br>
                    <input type="password" name="password" id="password" placeholder="Password" required><br>
                    <input type="submit" class="round_orange_buttons" id="popUplogInButton" value ="LOG IN"><br>
                    <div id="invalidLoginMessage" >Invalid Login credentials</div>
                </form>
                <button id="changePasswordButton" onclick="change_password();">Forgot your username or password?</button>
                <div id="signUpHeader">Don&apos;t have an account?</div>
                <a id="signupButton" href="create.php" >Sign Up</a>
            </div>
        </div>
        <div id="changePasswordRectangle">
            <div id="headerChangePasswordRectangle">Password Reset
                <button id="exitChangePasswordButton" onclick="resetLogInWindow();"> &#10006; </button>
            </div>
            <div id="passwordResetInformation">Enter your SkillCourt email address that you used to register. We&apos;ll send you an email with your username and a link to reset your password.</div>
            <form action="change_password.php" method="POST" name="change_password_form">
                <input type="text" name="emailAddressForPasswordChange" id="emailAddressForPasswordChange" placeholder="Email Address" required><br>
                <input class="round_orange_buttons" type="submit" id="submitPasswordChange" value="SEND"><br>
            </form>
        </div>
    </div>
    <div id="fade" class="black_overlay"></div>
    <div id="informationRectangle" class="default_rectangle_color">
    <div id="informationRectangleHeader" >Welcome to SkillCourt!</div>
<div id="textRectangle">
There is a lot involved with the training of soccer players.  The current system for training is primitive usually involving an instructor and a physical field for playing.  The primary objective is to produce a modern system for training soccer players.  The system will be a program with features that will assist players for learning the skills required on their own.<br/>
​<br/>
Implementing this system is revolutionary to the way avid players train in the sport.  With the functionality and portability that SkillCourt offers, the user can create a personalized regimen for improving skills. Thus, SkillCourt offers an overall improvement to both the soccer training and playing experience for players.<br/>
</div>
        <div><img src="style/images/room.png" id="roomPicture" alt=""></div>
    </div>
    <div id="pageFooter"></div>
</body>
</html>
