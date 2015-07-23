
Parse.initialize("pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF", "JO3sLj47GgaQXiX1zbdHhim5YbpbgiYy3JhYpx9w");

function enableFields(id)
{
    document.getElementById("firstNameInput").disabled = false;
    document.getElementById("lastNameInput").disabled = false;
    document.getElementById("middleInitialInput").disabled = false;
    document.getElementById("genderInput").disabled = false;
    document.getElementById("phoneInput").disabled = false;
    document.getElementById("birthDateInput").disabled = false;
    //document.getElementById("usernameInput").disabled = false;
    //document.getElementById("passwordInput").disabled = false;
    document.getElementById("positionInput").disabled = false;
    //document.getElementById("emailInput").disabled = false;
    document.getElementById("editProfileButton").style.display = "none";
    document.getElementById("submitButton").style.display = "block";
}

var currentCommand = "";
var isFirstClick = true ;

$(document).ready(function(){

                  $(".scroll button").click(function(){
                                            
                                            
                                    if (!isFirstClick)
                                            {$(".scroll button [value='"+currentCommand+"']").css("font-size","15px");
                                             $(".scroll button [value='"+currentCommand+"']").css("color","white");}
                                            else isFirstClick = false ;
                                            $(this).css("font-size","15px");
                                    $(this).css("color","rgb(236, 142, 75)");
                                    currentCommand = $(this).val();
                                            //alert(currentCommand);
                                    });
                  
                  
                  $("#listOfPlayersSelect").change(function(){
                                               
                                                   var x = document.getElementById("listOfPlayersSelect").value;
                                                   
                                                   document.getElementById("releasePlayerFromCoachButton").style.display = "block";
                  
                                               });
                  
                  $("#releasePlayerFromCoachButton").click(function(){
                                            
                                            
                                            console.log("Clicked Release")
                                            
                                                           var message = "playerUsername=" + document.getElementById("listOfPlayersSelect").value;
                                                           $.post("release_player.php",message,function(data,status){
                                                                  //console.log(data);
                                                                  alert(data);
                                                                  window.location.assign("managePlayers.php");
                                                                  })
                                            });
                  
                  });

function playRoutine()
{
    if (currentCommand != "")
    {
        var c = currentCommand.charAt(0);
        if (c == "U")
        {
            console.log("Com: "+currentCommand);
            window.location.assign("simulator.php?rc="+currentCommand+"&rt=U");
        } else {
            window.location.assign("simulator.php?rc="+currentCommand);
        }
    }
}


function change_password()
{
    console.log("change Password");
    document.getElementById("logInRectangle").style.display = "none";
    document.getElementById("changePasswordRectangle").style.display = "block";
}

function resetLogInWindow()
{
    document.getElementById("changePasswordRectangle").style.display = "none";
    document.getElementById("logInRectangle").style.display = "block";
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

function validateSignUp()
{
    var firstName = document.getElementById("createFirstNameInput").value;
    var middleName = document.getElementById("createMiddleNameInput").value;
    var lastName = document.getElementById("createLastNameInput").value;
    var phone = document.getElementById("createPhoneInput").value;
    var gender = document.getElementById("createGenderInput").value;
    var position = document.getElementById("createPositionInput").value;
    var birthdate = document.getElementById("createBirthdateInput").value;
    var username = document.getElementById("createUsernameInput").value;
    var password = document.getElementById("createPasswordInput").value;
    var email = document.getElementById("createEmailInput").value;
    var isCoach = document.getElementById("createCoachInput").checked;
    
    console.log(birthdate);
    console.log(position);
    
    
    var user = new Parse.User();
    user.set("firstName",firstName);
    user.set("lastName",lastName);
    user.set("middleInitial",middleName);
    user.set("phone",phone);
    user.set("gender",gender);
    user.set("position",position);
    user.set("birthdate",birthdate);
    user.set("username",username);
    user.set("password",password);
    user.set("email",email);
    user.set("isCoach",isCoach);
    
    user.signUp(null, {
                success: function(user) {
                // Hooray! Let them use the app now.
                window.location.assign("index.php");
                },
                error: function(user, error) {
                // Show the error message somewhere and let the user try again.
                alert("Error: " + error.code + " " + error.message);
                }
                });
}



