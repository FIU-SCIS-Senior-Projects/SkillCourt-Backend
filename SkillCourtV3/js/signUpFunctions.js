Parse.initialize("pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF", "JO3sLj47GgaQXiX1zbdHhim5YbpbgiYy3JhYpx9w");

function validatePartialSignUp()
{
    var username = $(".popover #createUsernameInput").val();
    var password = $(".popover #createPasswordInput").val();
    var email = $(".popover #createEmailInput").val();

    var user = new Parse.User();
    user.set("username",username);
    user.set("password",password);
    user.set("email",email);
    //Lets assign the default flags to the newly added user
    user.set("isPersComplete", false);
    user.set("isAthComplete", false);
    user.set("isVarComplete", false);
    user.set("isCoach", false);
            
    user.signUp(null, {
        success: function(user){
            //Succesfully sign in
            window.location.assign("index.php");
            alert("Confirm your e-mail address and log in!");
        },
        error: function(user, error){
            //Show error message
            alert("Error: ") + error.code + " " + error.message;
        }
    });
}

function checkPass()
{
    //Store the password field objects into variables ...
    var pass1 = $(".popover #createPasswordInput").val();
    var pass2 = $(".popover #confirmPasswordInput").val();
    //Store the Confimation Message Object ...
    var message = $(".popover #confirmMessage").val();
    //Set the colors we will be using ...
    var goodColor = "#66cc66";
    var badColor = "#ff6666";
    //Compare the values in the password field 
    //and the confirmation field
    if(pass1 == pass2){
        //The passwords match. 
        //Set the color to the good color and inform
        //the user that they have entered the correct password 
        $(".popover #confirmPasswordInput").css("backgroundColor", goodColor);
        $(".popover #confirmMessage").css("color", goodColor);
        $(".popover #confirmMessage").text("Passwords Match!");
    }else{
        //The passwords do not match.
        //Set the color to the bad color and
        //notify the user.
        $(".popover #confirmPasswordInput").css("backgroundColor", badColor);
        $(".popover #confirmMessage").css("color", badColor);
        $(".popover #confirmMessage").text("Passwords Do Not Match!");
    }
} 

function validatePersonalSignUp()
{
    var fn = document.getElementById("first_name").value;
    var ln = document.getElementById("last_name").value;
    var mn = document.getElementById("middle_name").value;
    var gender = document.getElementById("gender").value;
    var altemail = document.getElementById("altemail").value;
    var phone = document.getElementById("phone").value;

    var currentUser = Parse.User.current();
    currentUser.set("firstName", fn);
    currentUser.set("lastName", ln);
    if(mn != null){
        currentUser.set("middleInitial", mn);
    }
    currentUser.set("phone", phone);
    currentUser.set("gender", gender);
    if(altemail != null){
        currentUser.set("altEmail", altemail);
    }
    
    currentUser.save(null, {
        success: function(currentUser){
            currentUser.set("isPersComplete", true);
            if(currentUser.save()){
                window.location.assign("index.php");
            }
        },
        error: function(user, error){
            //Show error message
            alert("Error: ") + error.code + " " + error.message;
        }
    });
}

function validateAthleticSignUp()
{
    var position = document.getElementById("createPositionInput").value;
    var isCoach = document.getElementById("isCoach").value;
    var preferredFoot = document.getElementById("preferredFoot").value;

    
    var token = Parse.User.current().getSessionToken();
    Parse.User.become(token).then(function (currentUser) {
        // The current user is now set to user.
        currentUser.set("position", position);
        if(isCoach == 'Y'){
            currentUser.set("isCoach", true);
        }else{
            currentUser.set("isCoach", false);
        }
        currentUser.set("preferredFoot", preferredFoot);
        
        currentUser.save(null, {
            success: function(currentUser){
                currentUser.set("isAthComplete", true);
                if(currentUser.save()){
                    window.location.assign("index.php");
                }
            },
            error: function(user, error){
                //Show error message
                alert("Error: ") + error.code + " " + error.message;
            }
        }); 
    }, function (error) {
        // The token could not be validated.
    });
}

function validateVariousSignUp()
{
    var teamsArr = [];
    var inputArray = [];
    $(function(){
        $("input[name='teams']").each(function(i){
            teamsArr.push($(this).val().toLowerCase().trim());
        });
    });

    var token = Parse.User.current().getSessionToken();
    Parse.User.become(token).then(function (currentUser) {
        // The current user is now set to user.
        //Add functionality for adding on to an existing array if any
        if(currentUser.get("favTeams") == null){
            //Then there is nothing here!
            //Go ahead and save
            currentUser.set("favTeams", teamsArr);
        }else{
            //We got something here. Get that in an array, and append it to the newly added array. 
            inputArray = currentUser.get("favTeams");
            //Make sure we dont have duplicates
            for (var i = 0; i < teamsArr.length; i++) {
                if(inputArray.indexOf(teamsArr[i]) === -1){
                    inputArray.push(teamsArr[i]);
                }else if(inputArray.indexOf(teamsArr[i]) > -1){
                    console.log(teamsArr[i] + 'Already exists in the Teams');
                }
            };
            currentUser.set("favTeams", inputArray);
        }
        currentUser.save(null, {
            success: function(currentUser){
                currentUser.set("isVarComplete", true);
                if(currentUser.save()){
                    window.location.assign("index.php");
                }
            },
            error: function(user, error){
                //Show error message
                alert("Error: ") + error.code + " " + error.message;
            }
        });
    }, function (error) {
      // The token could not be validated.
    });
}

function removeTeam(e)
{
    e.preventDefault();
    var teamToRemove = $(this).parent().find('strong').text().toLowerCase().trim();
    var sessionToken = Parse.User.current().getSessionToken();
    Parse.User.become(sessionToken).then(function (currentUser) {
        // The current user is now set to user.
        var inputArray = currentUser.get("favTeams");

        var i = inputArray.indexOf(teamToRemove);
        if(i != -1){
            inputArray.splice(i, 1);
        }
        currentUser.set(inputArray);
        currentUser.save(null, {
            success: function(currentUser){
                if(inputArray.length == 0){
                    currentUser.set("isVarComplete", false);
                }
                if(currentUser.save()){
                    window.location.assign("index.php");
                }
            },
            error: function(currentUser, error){
                //Show error message
                alert("Error: ") + error.code + " " + error.message;
            }
        });
    }, function (error) {
      // The token could not be validated.
    });
}

function disableCoach()
{
    if (!document.getElementById("createCoachInput").checked)
    {
        document.getElementById("createPositionInput").value = "Goalkeeper";
        document.getElementById("createPositionInput").disabled = false;
    } else {
        document.getElementById("createPositionInput").value = "Coach";
        document.getElementById("createPositionInput").disabled = true;
    }
}

function changeFunc(i){
    var positionInput = document.getElementById("createPositionInput");
    if(i == 'Y')
    {
        positionInput.value = "Coach";
        positionInput.disabled = true;
    }
    else
    {
        positionInput.value = "";
        positionInput.disabled = false;
    }
}

//Get sessionToken, store it in localstorage, and use it across the 
function validateUser()
{
    $.ajax({
        type: 'POST',
        url: './inc/sessiontoken.php',
        data: '',
        success : function(data){
            storeSeshToken(data);
        }
    });
}
function storeSeshToken(data)
{
    var seshToken = data;
    Parse.User.become(seshToken).then(function (currentUser) {
        // The current user is now set to user.
        console.log(currentUser.get('email'));
    }, function (error) {
      // The token could not be validated.
    });
}


$(document).on("click", ".remove_team", removeTeam);
$(document).one('ready', function() {
    if (document.getElementById('validateUser')) {
        validateUser();
    }
});