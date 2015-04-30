var User = null;

function Login() {
    'use strict';
    var username = document.getElementById('username').value,
        password = document.getElementById('password').value;
    if (username === "" || password === "") {
        alert("Please fill in username and password fields");
        return false;
    }
    $.post("http://skillcourt-dev.cis.fiu.edu/mat_login/log_in.php", {username: username, password: password}, function (data) {
        if (data.trim() === "Valid") {
            successfulLogin(username);
            window.location.href = "./Main.html"; //redirect the user
        } else {
            alert("Invalid Username/Password combination.  Try again.");
            return false;
        }
    });
    return false;
}

function successfulLogin(user) {
    'use strict';
    User = user;
}

function Logout() {
    'use strict';
    User = null;
    window.location.href = "./Login.html";
}

function checkLoginStatus() {
    'use strict';
    if (User === null) {
        return "Login";
    } else {
        return User;
    }
}
