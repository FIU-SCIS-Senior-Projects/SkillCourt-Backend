<?php
if($userNotLogged)
{
	if(isset($_GET['show']))
    {
        $page = $_GET['show'];

        switch ($page) {
            case 'about':
                 //about.php
                include_once './view/about.php';
                break;
            }
    }

    else {
        echo " 
    <br/>
    
    <div class=\"container contBorders modifyText\">
        <div class=\"row\">
            <div class=\"col-md-12 text-center\">
                <!-- Interactive Table -->

                 <div style=\"width:1120px; height:530px; margin-left:8px; margin-top: 12px; padding-top:15px;
                 font-family:Arial, Helvetica, sans-serif; color:#FFF; text-align:left; background-color:#F4F4F4;
                 -moz-border-radius: 8px; border-radius: 8px; border-color:#CCC; border-style:solid; border-width:thin;\">

                    <div id=\"nav\" style=\"width:260px; height:480px; float:left; margin-top:10px; 
                    border-right-color:#CCC; border-right-style:solid; border-right-width:thin; padding-right:22px; 
                    margin-left:5px; padding-left:15px; font-weight:bold; font-size:14px;\">

                         <a id=\"goto1\" style=\"cursor:pointer;\" onclick=\"liveVideo.play()\">
                            <div style=\"width:229px; height:64px;\" onmouseover=\"this.style.opacity=0.8;this.filters.alpha.opacity=80\" 
                            onmouseout=\"this.style.opacity=1;this.filters.alpha.opacity=100\">
                    
                                <div style=\"position:absolute; z-index:99; margin-top:20px; margin-left:15px; color:white;\">Live Demo</div>
                                <img src=\"img/BgrndTabbedTitlesLiveVideo.png\" width=\"229\" height=\"64\" border=\"0\" />
                            </div>          
                        </a>

                        <a id=\"goto2\" style=\"cursor:pointer;\" onclick=\"liveVideo.pause()\">
                            <div style=\"width:229px; height:64px; margin-top:5px;\" onmouseover=\"this.style.opacity=0.8;this.filters.alpha.opacity=80\" 
                            onmouseout=\"this.style.opacity=1;this.filters.alpha.opacity=100\">
                    
                                <div style=\"position:absolute; z-index:99; margin-top:20px; margin-left:15px; color:white;\">SkillCourt</div>
                                <img src=\"img/BgrndTabbedTitles.png\" width=\"229\" height=\"64\" border=\"0\" />
                            </div>          
                        </a>

                        <div style=\"position:absolute; z-index:99; margin-top:10px; margin-left:15px; color:white;\">User Modes</div>
                        <img src=\"img/MainBgrndTabbedTitles.png\" width=\"229\" height=\"35\" border=\"0\" style=\"margin-top:2px; margin-bottom:-2px;\" />
                   
                        <a id=\"goto3\" style=\"cursor:pointer;\" onclick=\"liveVideo.pause()\">
                            <div style=\"margin-top:5px;\" onmouseover=\"this.style.opacity=0.8;this.filters.alpha.opacity=80\" 
                            onmouseout=\"this.style.opacity=1;this.filters.alpha.opacity=100\">
                
                                <div style=\"position:absolute; z-index:99; margin-top:20px; margin-left:15px; color:white;\">Player</div>
                                <img src=\"img/BgrndTabbedTitles.png\" width=\"229\" height=\"64\" border=\"0\" />
                            </div>
                        </a>

                        <a id=\"goto4\" style=\"cursor:pointer;\" onclick=\"liveVideo.pause()\">
                            <div style=\"margin-top:5px;\" onmouseover=\"this.style.opacity=0.8;this.filters.alpha.opacity=80\" 
                            onmouseout=\"this.style.opacity=1;this.filters.alpha.opacity=100\">
                
                                <div style=\"position:absolute; z-index:99; margin-top:20px; margin-left:15px; color:white;\">Coach</div>
                                <img src=\"img/BgrndTabbedTitles.png\" width=\"229\" height=\"64\" border=\"0\" />
                            </div>
                        </a>

                        <div style=\"position:absolute; z-index:99; margin-top:10px; margin-left:15px; color:white;\">Components</div>
                        <img src=\"img/MainBgrndTabbedTitles.png\" width=\"229\" height=\"35\" border=\"0\" style=\"margin-top:2px; margin-bottom:-2px;\" />

                        <a id=\"goto5\" style=\"cursor:pointer;\" onclick=\"liveVideo.pause()\">
                            <div style=\"margin-top:5px;\" onmouseover=\"this.style.opacity=0.8;this.filters.alpha.opacity=80\" 
                            onmouseout=\"this.style.opacity=1;this.filters.alpha.opacity=100\">
                                
                                <div style=\"position:absolute; z-index:99; margin-top:20px; margin-left:15px; color:white;\">Simulator</div>
                                <img src=\"img/BgrndTabbedTitles.png\" width=\"229\" height=\"64\" border=\"0\" />
                            </div>
                        </a>

                        <a id=\"goto6\" style=\"cursor:pointer;\" onclick=\"liveVideo.pause()\">
                            <div style=\"margin-top:5px;\" onmouseover=\"this.style.opacity=0.8;this.filters.alpha.opacity=80\" 
                            onmouseout=\"this.style.opacity=1;this.filters.alpha.opacity=100\">
                                
                                <div style=\"position:absolute; z-index:99; margin-top:20px; margin-left:15px; color:white;\">Routine Wizard</div>
                                <img src=\"img/BgrndTabbedTitles.png\" width=\"229\" height=\"64\" border=\"0\" />
                            </div>
                        </a>
                    </div>
  
                    <div id=\"s1\" style=\"width:800px; height:220px; float:left; margin-top:10px; margin-left:22px; text-align:left;\">
                        
                        <!-- Live Demo Tab View -->
                        <div style=\"display:none; background-color:#F4F4F4; height:150px;\">
                        
                            <div style=\"font-size:21px; color:#2f7b2a;\">
                                <!-- Video Frame -->
                                <video class=\"videoBorder\" width=\"790\" height=\"444\" id=\"liveVideo\" autoplay controls muted>
                                    <source src=\"./videos/SkillCourtShowcase.mp4\" type=\"video/mp4\">
                                    Upgrade you browser to see video!.
                                </video>
                            </div>                         
                        </div>
                        <!-- -->

                        <!-- SkillCourt Tab View -->
                        <div style=\"background-color:#F4F4F4; height:150px;\">
                        
                            <div style=\"font-size:25px; color:#2f7b2a;\">
                                 The objective is to produce a modern system for training soccer players
                            </div>
                        
                            <div style=\"font-size:19px; color:#666; margin-top:35px; line-height:20px;\">
                                There is a lot involved with the training of soccer players. The current system for training 
                                is primitive usually involving an instructor and a physical field for playing. The system will 
                                be a program with features that will assist players for learning the skills required on their 
                                own.<br /><br />
                            
                                <div style=\"float:right; width:400px; height:150px; margin-top:30px; margin-left:-600px; margin-right:30px;\">
                                    Implementing this system is revolutionary to the way avid players train in the sport.
                                </div>

                                <div>
                            
                                    <div style=\"float:left; width:336px; height:285px; margin-top:20px;\">
                                    <img src=\"img/room.png\" width=\"336\" height=\"285\" border=\"0\" />
                                    </div>
                                
                                    <div style=\"float:left; width:400px; height:300px; margin-top:125px; margin-left:35px;\">
                                        With the functionality and portability that SkillCourt offers, the user can create a 
                                        personalized regimen for improving skills. Thus, SkillCourt offers an overall improvement 
                                        to both the soccer training and playing experience for players.
                                    </div>
                            
                                </div> 
                            </div>
                        </div>
                        <!-- -->

                        <!-- Player Tab View -->
                        <div style=\"display:none; background-color:#F4F4F4; height:150px;\">
                        
                            <div style=\"font-size:25px; color:#2f7b2a;\">
                                 Players improve their cognitive and reaction skills playing the simulator
                            </div> 

                            <div style=\"font-size:19px; color:#666; margin-top:35px; line-height:20px;\">
                                Users logged-in as players have access to the simulator that comes with pre-defined routines. Moreover,
                                registered players will get specific routines designed by their coaches. Player's performance and statistics
                                for different routines are recorded and easily available for comparison that shows the areas that need improvement.  
                                <br /><br />
                        
                                <div style=\"position:absolute; z-index:99; margin-left:170px; margin-top:60px; width:330px; height:90px;\">
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Simulator Access<br>
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Pre-defined Routines<br>
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Messages Inbox<br>
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Routine Statistics<br>
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Position Selection
                                </div>

                                <div style=\"width:336px; height:285px; margin-top:10px; margin-left:430px;\">
                                    <img src=\"img/SkillCourtRoutines.png\" width=\"180\" height=\"285\" border=\"0\" />
                                </div>                                                             
                                
                            </div>                        
                        </div>
                        <!-- -->

                        <!-- Coach Tab View -->
                        <div style=\"display:none; background-color:#F4F4F4; height:150px;\">
                        
                            <div style=\"font-size:25px; color:#2f7b2a;\">
                                 Coaches design and assign routines through the use of the wizard
                            </div> 

                            <div style=\"font-size:19px; color:#666; margin-top:35px; line-height:20px;\">
                                Users logged-in as coaches have access to the routine wizard. Coaches can create any particular routine.
                                These then, can be assigned to specific registered player(s), or to a postition which will assign the routine
                                to all players registered with that position. Coaches are able to track players' performance to help then determine
                                the areas that need more work.  
                                <br /><br />
                        
                                <div style=\"position:absolute; z-index:99; margin-left:130px; margin-top:60px; width:330px; height:90px;\">
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Routine Wizard Access<br>
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Routine Assignment<br>
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Messages Inbox<br>
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Player Routine Statistics<br>
                                     <img src=\"img/SmallRoundCheckMark.png\" width=\"12\" height=\"12\" border=\"0\" align=\"absmiddle\"> Player Sign/Release
                                </div>

                                <div style=\"width:336px; height:285px; margin-top:10px; margin-left:390px;\">
                                    <img src=\"img/PlayerSignRelease.png\" width=\"280\" height=\"280\" border=\"0\" />
                                </div>                                                             
                                
                            </div>                        
                        </div>
                        <!-- -->

                        <!-- Simulator Tab View -->
                        <div style=\"display:none; background-color:#F4F4F4; height:150px;\">
                        
                             <div style=\"font-size:25px; color:#2f7b2a;\">
                                 Pure improvement of cognitive and reaction skills
                            </div>
                        
                            <div style=\"font-size:19px; color:#666; margin-top:35px; line-height:20px;\">
                                The simulator brings a representation of the product's vision. Users registered as players are able to run over
                                default-generated routines or specific routines designed by coaches. The simulator provides statistical feedbacks
                                about the user's perfomance over the chosen routine.
                                <br /><br />
                        
                                <div>
                            
                                    <div style=\"float:left; width:336px; height:285px; margin-top:20px;\">
                                    <img src=\"img/SimulatorTab.png\" width=\"790\" height=\"285\" border=\"0\" />
                                    </div>
                                                                                            
                                </div> 
                            </div>
                        </div>
                        <!-- -->

                         <!-- Routine Wizard Tab View -->
                        <div style=\"display:none; background-color:#F4F4F4; height:150px; margin-top:-19px\">
                        
                            <<div style=\"font-size:25px; color:#2f7b2a;\">
                                 Specific customizations to simulate any particular skill
                            </div>
                        
                            <div style=\"font-size:19px; color:#666; margin-top:35px; line-height:20px;\">
                                With many different steps and rounds, the wizard helps users registered as coaches 
                                to create unique routines to shape any desirable aspect of a skill. These can then be assigned
                                to a group of players as general, for players with an specific soccer position, and/or to any registered
                                player.
                                <br /><br />
                        
                                <div>
                            
                                    <div style=\"float:left; width:336px; height:285px; margin-top:20px;\">
                                    <img src=\"img/WizardTab.png\" width=\"790\" height=\"285\" border=\"0\" />
                                    </div>
                                                                                            
                                </div> 
                            </div>
                        </div>
                        <!-- -->
                    
                    </div>         
                </div>
            </div>
        </div>
        
        <script>
            var vid = document.getElementById(\"livevideo\");

            function playVid() {
                livevideo.play();
            } 

            function pauseVid() {
                livevideo.pause();
            }
        </script>
    ";
    }
}
else
{
    
	if(isset($_GET['show']))
    {
        $page = $_GET['show'];

        switch ($page) {
            case 'home':
                //Index page
            include_once './view/home.php';
                break;
            case 'about':
                 //about.php
            	include_once './view/about.php';
                break;
            case 'help':
                //help.php
            	include_once './view/help.php';
                break;
            case 'routinesCoach':
                //routinesCoach.php
                //Set variables for MVC section
                if(isset($_GET['controller']) && isset($_GET['action']))
                {
                    $controller = $_GET['controller'];
                    $action     = $_GET['action'];
                }else{
                    $controller = 'pages';
                    $action     = 'routinesHome';
                }
            	include_once './view/routinesCoach.php';
                break;
            case 'wizard':
                //wizard.php
            	include_once './view/wizard.php';
                break;
            case 'players':
                //players.php
                //Set variables for MVC section
                if(isset($_GET['controller']) && isset($_GET['action']))
                {
                    $controller = $_GET['controller'];
                    $action     = $_GET['action'];
                }else{
                    $controller = 'pages';
                    $action     = 'home';
                }
            	require_once './view/players.php';
                break;
            case 'routinesPlayer':
                //routinesPlayer.php
            	include_once './view/routinesPlayer.php';
                break;
            case 'simulator':
                //simulator.php
	            include_once './view/simulator.php';
                break;
            case 'profile':
                //profile.php
	            include_once './view/profile.php';
                break;
            default:
                echo "Somewhere else";
                break;
        }
    }
}