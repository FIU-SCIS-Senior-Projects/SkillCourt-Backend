var currentCommand = "";
var isFirstClick = true ;

$(document).ready(function(){

    $(".scroll button").click(function(){
                            
        // if (!isFirstClick)
        // {
        //     $(".scroll button [value='"+currentCommand+"']").css("font-size","15px");
        //     $(".scroll button [value='"+currentCommand+"']").css("color","white");
        // }
        // else 
        //     isFirstClick = false ;
        
        // $(this).css("font-size","15px");
        // $(this).css("color","white");
        currentCommand = $(this).val();
                //alert(currentCommand);
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
            window.location.assign("./index.php?show=simulator&rc="+currentCommand+"&rt=U");
        } else {
            window.location.assign("./index.php?show=simulator&rc="+currentCommand);
        }
    }
}