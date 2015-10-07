Parse.initialize("pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF", "JO3sLj47GgaQXiX1zbdHhim5YbpbgiYy3JhYpx9w");

function loginUsers(e)
{
    e.preventDefault();
    var username = $('#username').val().trim();
    var password = $('#password').val().trim();

    // var curUser = Parse.User.current();
    // if(curUser){
    //  console.log('this guy is logged ' + curUser.get('username'));
    // }
    if(username != null && password != null){
        Parse.User.logIn(username, password,{
            success : function(user){
                //Reroute the user to their newly created account. 
                console.log('user login succesful');
                console.log(user.get('email'));
                $.ajax({
                    url: './inc/process_login.php',
                    type: 'post',
                    data: {'action' : 'login', 'token': user.getSessionToken()},
                        success: function(data, status) {
                            console.log(data + " " + status);
                            location.reload();
                        },
                        error: function(xhr, desc, err) {
                            console.log(xhr);
                            console.log("Details: " + desc + "\nError:" + err);
                        }
                }); // end ajax call



            },
            error : function(user, error){
                //The login failed. there might be an invalid user or password. 
                console.log('user login failed');
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
                    location.reload();
                },
                error: function(xhr, desc, err) {
                    console.log(xhr);
                    console.log("Details: " + desc + "\nError:" + err);
                }
        }); // end ajax call
    }
}


//Events
$(document).on("click", "#loginButton", loginUsers);
$(document).on("click", ".logUserOut", logoutUsers);

