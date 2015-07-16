<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>SkillCourt</title>
        <link rel="stylesheet" type="text/css" href="style/Main.css">
    </head>
    <body>
        <div id="MainData">
            <div id="Header">SkillCourt</div>
            <div id="User"></div>
            <div id="Menu">
                <h2><a href="Main.php">Home</a></h2>
                <h2><a href="routines.php">Routines</a></h2>
            </div>
            <div id="Content">
                <h1>Profile:</h1>
                <form onsubmit="">
                <table>
                    <tr><td>Current Password:</td> <td><input type="password" id="pw"></td></tr>
                    <tr><td>New Password:</td> <td><input type="password" id="npw"></td></tr>
                    <tr><td>Confirm New Password:</td> <td><input type="password" id="npwc"></td></tr>
                    <tr><td>Current coach:</td> <td align="center"></td></tr>
                    <tr><td>New Coach:</td> <td><input type="text" id="coach"></td></tr>
                    <tr><td>Privacy Settings</td></tr>
                    <tr><td>Set to private:</td><td><input type="checkbox" name"private" value="P"></td></tr>
                    <tr><td></td> <td align="right"><input type="button" value="Confirm Changes"></td></tr>
                </table>
                </form>
            </div>
            <div id="Footer">Copyright 2015 SkillCourt</div>
        </div>
    </body>
</html>

