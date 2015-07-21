/*Parse.initialize("pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF", "JO3sLj47GgaQXiX1zbdHhim5YbpbgiYy3JhYpx9w");

var currentUser = Parse.User.current();*/

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
                  
                  
                  $("#createCoachInput").change(function(){
                                               
                                        
                  
                                               });
                  });

function playRoutine()
{
    console.log("Hello world");
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
    
}

