<?php
    
    include_once("parseHeader.php");
    
    use Parse\ParseObject;
    use Parse\ParseException;
    
    $errorMessage  = "" ;
    
    if (isset($_GET["error"])) {
        $errorMessage = "Invalid Login Credentials";
        echo $errorMessage;
    }
    
?>

<!DOCTYPE HTML>
<html>
    <head>
        <title>Secure Login: Log In</title>
        <link rel="stylesheet" href="style/index.css" />
        <meta charset="UTF-8">
    </head>
    <body>
        <div id="navigationBar">
            <div class="navigationButtons" id="buttonGroup">
                <button id="homeButton" onclick="location.href = 'Main.php';">Home</button>
                <button id="aboutButton">About</button>
            </div>
        </div>
        <button id="logInButton" href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='block';document.getElementById('fade').style.display='block'; document.getElementById('logInRectangle').style.display='block' ; document.getElementById('headerLogInRectangle').style.display='block';">Log In</button>
        <div id="light" class="white_content">This is the lightbox content. <a href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none' ">Close</a>
            <div id="logInRectangle"></div>
            <div id="headerLogInRectangle">Log In or Create an Account</div>
        </div>
        <div id="fade" class="black_overlay"></div>
        <div id="rectangle2"> </div>
        <div id="informationRectangle"></div>
        <div id="textRectangle">
            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&apos;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
        </div>
        <form action="process_login.php" method="POST" name="login_form">
            <input type="text" name="username" id="username"><br>
            <input type="password" name="password" id="password"><br>
            <input type="submit" id="signinbutton"><br>
        </form>
        <div id="text"> SkillCourt </div>
    </body>
</html>
