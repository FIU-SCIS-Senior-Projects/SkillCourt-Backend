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
    currentUser.set("isPersComplete", true);
    if(currentUser.save())
    {
        window.location.assign("index.php");
    }
}

function validateAthleticSignUp()
{
    var position = document.getElementById("createPositionInput").value;
    var isCoach = document.getElementById("isCoach").value;
    var preferredFoot = document.getElementById("preferredFoot").value;

    console.log(position + " " + isCoach + " " + preferredFoot);
    var currentUser = Parse.User.current();
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
        }
    });
}

function validateVariousSignUp()
{
    var teamsArr = [];
    $(function(){
        $("input[name='teams']").each(function(i){
            console.log(i + ": " + $( this ).val());
            teamsArr.push($(this).val());
        });
    });
    var currentUser = Parse.User.current();
    currentUser.set("favTeams", teamsArr);
    currentUser.save(null, {
        success: function(currentUser){
            currentUser.set("isVarComplete", true);
            if(currentUser.save()){
                window.location.assign("index.php");
            }
        }
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