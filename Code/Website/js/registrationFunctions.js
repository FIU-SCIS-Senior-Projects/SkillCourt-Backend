Parse.initialize("pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF", "JO3sLj47GgaQXiX1zbdHhim5YbpbgiYy3JhYpx9w");

function loginUsers(e)
{
    e.preventDefault();
    var username = $('#username').val().trim();
    var password = $('#password').val().trim();

    if(username != null && password != null){
        Parse.User.logIn(username, password,{
            success : function(user){
                //Reroute the user to their newly created account. 
                $.ajax({
                    url: './inc/process_login.php',
                    type: 'post',
                    data: {'action' : 'login', 'token': user.getSessionToken()},
                        success: function(data, status) {
                            console.log(data + " " + status);
                            window.location.assign('./index.php?show=profile');
                        },
                        error: function(xhr, desc, err) {
                            console.log(xhr);
                            console.log("Details: " + desc + "\nError:" + err);
                        }
                }); // end ajax call
            },
            error : function(user, error){
                //The login failed. there might be an invalid user or password. 
                loginFailed();
            }
        }); 
    }
    else
    {
        console.log('Enter something in password and username');
    }
}

function logoutUsers(e)
{
    e.preventDefault();
    Parse.User.logOut();
    var currentUser = Parse.User.current();
    if(currentUser == null)
    {
        $.ajax({
            url: './inc/process_login.php',
            type: 'post',
            data: {'action' : 'logout'},
                success: function(data, status) {
                    console.log(data + " " + status);
                    window.location.assign('./index.php');
                },
                error: function(xhr, desc, err) {
                    console.log(xhr);
                    console.log("Details: " + desc + "\nError:" + err);
                }
        }); // end ajax call
    }
}

function verifyEmail(callback)
{
    var isReset = false;
    var email = $('#emailAddressForPasswordChange').val();
    var query = new Parse.Query(Parse.User);
    query.equalTo("email", $('#emailAddressForPasswordChange').val());  // find all the user's with this email
    query.find({
        success: function(results) {
            if(results.length <= 0){
                //This email does not exist
                isReset = false;
                callback(isReset);
            }
            else{
                isReset = true;
                callback(isReset);
            }
        }
    });
}

function resetPwd()
{
    //Reset this password
    var email = $('#emailAddressForPasswordChange').val();
    Parse.User.requestPasswordReset(email, {
    success: function() {
        // Password reset request was sent successfully
        console.log("successful request");
    },
    error: function(error) {
        // Show the error message somewhere
        console.log("Error: " + error.code + " " + error.message);
    }
    });
}

function validateEmail(email) {
    var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return re.test(email);
}

function loginFailed()
{
    //Prompt the user to login again
    $('#password').tooltip('toggle');
}

//Events
$(document).on("click", "#loginButton", loginUsers);
$(document).on("click", ".logUserOut", logoutUsers);
$(document).on("click", "#submitPasswordChange", resetPwd);
$(document).on("click", "#username, #password" ,function(){
    $('#password').tooltip('destroy');
});
$(document).ready(function(){
    var validEmail = false;
    $('#emailAddressForPasswordChange').on('input propertychange paste',function(){
        if(!validateEmail(this.value)){
            validEmail = false;
            return;
        }else{
            verifyEmail(function(resetBool){
                $('#submitPasswordChange').prop('disabled', resetBool ? false : true);
            });
        }
    });
});