// JavaScript Document

$(document).ready(function() {
   // Main Slider Cycle
    $('#s1').cycle({ 
	fx: 'none',
    timeout: 0, 
    speed:   300, 

    });
  
    // Tabbed Content
    $('#goto1').click(function() { 
        $('#s1').cycle(0); 
        return false; 
    }); 

    $('#goto2').click(function() {  
        $('#s1').cycle(1);  
        return false;  
    });

    $('#goto3').click(function() {  
        $('#s1').cycle(2);  
        return false;  
    });

    $('#goto4').click(function() {  
        $('#s1').cycle(3);  
        return false;  
    });

    $('#goto5').click(function() {  
        $('#s1').cycle(4);  
        return false;  
    });

});