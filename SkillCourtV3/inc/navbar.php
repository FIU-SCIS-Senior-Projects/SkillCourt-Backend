<?php
    $isCoach = $isPlayer = true;
    if($userNotLogged){
        //User has not logged in
        $isCoach = $isPlayer = false;
    }else{
        //User has logged in
        $currentUserIndex->fetch();
        $isCoach = $currentUserIndex->get("isCoach");
        if($isCoach){
            $isPlayer = false;
        }else{
            if($currentUserIndex->get("isAthComplete")){
                $isPlayer = true;
                $isCoach = false;
            }else{
                $isPlayer = false;
            }
        }
    }
?>

<!-- Navigation Bar Top-->
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <?php if(!$userNotLogged) : ?>
                <a class="navbar-brand" href="index.php?show=home">SkillCourt &copy;</a>
            <?php else : ?>
                <a class="navbar-brand" href="index.php">SkillCourt &copy;</a>
            <?php endif ?>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-left">
                <li id="aboutli"<?php echo (isset($_GET["show"]) && $_GET["show"] == "about") ? 'class=active' : ''; ?>><a id="about" href="index.php?show=about">About</a></li>
                <?php if(!$userNotLogged && $_GET["show"] == "simulator") : ?>
                    <li id="helpli"><a id="help" href="javascript:void(0);" onclick="simulatorguide.start();">Help</a></li>
                <?php endif ?>
                <?php if(!$userNotLogged && $_GET["show"] == "wizard") : ?>
                    <li id="helpli"><a id="help" href="javascript:void(0);" onclick="wizardguide.start();">Help</a></li>
                <?php endif ?>
            </ul>
            <?php if($userNotLogged) : ?>
                <!-- Login Form -->
                <form class="navbar-form navbar-right" method="POST" name="login_form">
                    <div class="form-group">
                        <input type="text" class="form-control input-sm" name="username" placeholder="Username" id="username" required>
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control input-sm" name="password" placeholder="Password" id="password" data-toggle="tooltip" data-trigger="manual" data-placement="bottom" title="Invalid credentials!" required>
                    </div>
                    <button type="submit" class="btn btn-link btn-lg topBannerIcon" data-toggle="tooltip" data-placement="bottom" title="Login" id="loginButton">
                        <span class="glyphicon glyphicon glyphicon glyphicon-log-in" aria-hidden="true"></span>
                    </button>
                    <button type="button" class="btn btn-link btn-lg topBannerIcon" data-toggle="modal" data-target="#passwordModal">
                        <span class="glyphicon glyphicon glyphicon-info-sign" aria-hidden="true"></span>
                    </button>
                </form>
            <?php endif?>
            <?php if($isCoach): ?> 
                <!-- This is the coach -->
                <ul class="nav navbar-nav navbar-right">
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "routinesCoach") ? 'class=active' : ''; ?>><a href="index.php?show=routinesCoach">Routines</a></li>
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "wizard") ? 'class=active' : ''; ?>><a href="index.php?show=wizard">Wizard</a></li>
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "players") ? 'class=active' : ''; ?>><a href="index.php?show=players">Players</a></li>
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "profile") ? 'class=active' : ''; ?>><a href="index.php?show=profile">Welcome <?php echo $username ?></a></li>
                    <li>
                        <button type="button" class="btn btn-link btn-lg topBannerIconUser logUserOut" data-toggle="tooltip" data-placement="bottom" title="Logout">
                            <span class="glyphicon glyphicon glyphicon glyphicon-log-out" aria-hidden="true"></span>
                        </button>
                    </li>
                </ul>
            <?php endif?>
            <?php if($isPlayer): ?>
                <!-- This is the player -->
                <ul class="nav navbar-nav navbar-right">
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "routinesPlayer") ? 'class=active' : ''; ?>><a href="index.php?show=routinesPlayer">Routines</a></li>
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "simulator") ? 'class=active' : ''; ?>><a href="index.php?show=simulator">Simulator</a></li>
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "profile") ? 'class=active' : ''; ?>><a href="index.php?show=profile">Welcome <?php echo $username ?></a></li>
                    <li>
                        <button type="button" class="btn btn-link btn-lg topBannerIconUser logUserOut" data-toggle="tooltip" data-placement="bottom" title="Logout">
                            <span class="glyphicon glyphicon glyphicon glyphicon-log-out" aria-hidden="true"></span>
                        </button>
                    </li>
                </ul>
            <?php endif?>
            <!-- This is a user that has not picked to be a player or a coach -->
            <?php if(!$isCoach && !$isPlayer && !$userNotLogged): ?>
                <ul class="nav navbar-nav navbar-right">
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "profile") ? 'class=active' : ''; ?>><a href="index.php?show=profile">Welcome <?php echo $username ?></a></li>
                    <li>
                        <button type="button" class="btn btn-link btn-lg topBannerIconUser logUserOut" data-toggle="tooltip" data-placement="bottom" title="Logout">
                            <span class="glyphicon glyphicon glyphicon glyphicon-log-out" aria-hidden="true"></span>
                        </button>
                    </li>
                </ul>
            <?php endif?>

        </div><!--/.nav-collapse -->
    </div>
</nav>


<!-- Reset your password Modal -->
<div class="modal fade" id="passwordModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Reset your Password</h4>
            </div>
            <div class="modal-body">
              
                <p>Enter your SkillCourt email address that you used to register. We'll send you an email with your username and a link to reset your password.</p>

                <form method="POST" name="change_password_form">    
                    <div class="form-group">
                        <label for="exampleInputEmail1">Email address</label>
                        <input class="form-control" placeholder="Enter email" type="email" id="emailAddressForPasswordChange" required>
                    </div>
                    <button disabled class="btn btn-primary" type="submit" name="submitPasswordChange" id="submitPasswordChange">Submit</button>                    
                </form>
                
            </div>
            
            <div class="modal-footer">
                <button class="btn btn-primary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

var simulatorguide = introJs();

$(function SimulatorTutorial(){
  // var startbtn   = $('#startdemotour');
  
  simulatorguide.setOptions({
    steps: [
    {
      element: '#bannerImg',
      intro: 'Welcome to SkillCourt Simulator Tutorial',
      position: 'bottom'
    },
    {
      element: '#SimSettings',
      intro: 'The phone represents the settings for the simulator and provides the feedback once the game has started',
      position: 'right'
    },
    {
      element: '#leTabs',
      intro: 'The DEFAULT option will show the pre-defined routines while CUSTOM the ones assigned by a coach',
      position: 'top'
    },
    {
      element: '#sStep4',
      intro: 'When checked, this option allows the player to remove a wall from the simulator',
      position: 'right'
    },
    {
      element: '#sStep5',
      intro: "List of pre-defined routines to simulate. Select your favorite or challenge yourself",
      position: 'left'
    },
    {
      element: '#difficultyRadioButton',
      intro: "Sets the difficulty for the routine. An increase in difficulty makes the correct spot to click more specific",
      position: 'right'
    },
    {
      element: '#sStep7',
      intro: "This option adds a time limit to each round narrowing the player's reaction time window",
      position: 'left'
    },
    {
      element: '#sStep8',
      intro: "Total time for the routine simulation",
      position: 'right'
    },
    {
      element: '#sStep9',
      intro: "Clicking PLAY! will start the simulator with routine and settings selected. Feedback is provided when simulation begins. Time to play!",
      position: 'top'
    }
    ]

  });
});
</script>

<script type="text/javascript">

var wizardguide = introJs();

$(function wizardTutorial(){
  // var startbtn   = $('#startdemotour');
  
  wizardguide.setOptions({
    steps: [
    {
      element: '#bannerImg',
      intro: 'Welcome to SkillCourt Wizard Tutorial',
      position: 'bottom'
    },
    {
      element: '#routineSwitch',
      intro: 'Switching to DEFAULT option allows you to create a routine based on the pre-defined system routines',
      position: 'left'
    },
    {
      element: '#stepType',
      intro: 'This option allows you to base the routine between wall or ground targets',
      position: 'right'
    },
    {
      element: '#simulator',
      intro: 'Select a group of pads to make up a target. Your pads must be adjacent and on the same wall. When the correct pads are selected, press the FINISH STEP button',
      position: 'right'
    },
    {
      element: '#wStep5',
      intro: "Routines are made of rounds, which are made of steps. This allows for deep and endless customizations",
      position: 'top'
    },
    {
      element: '#wStep6',
      intro: "(+) Adds an extra step to a round",
      position: 'right'
    },
    {
      element: '#wStep7',
      intro: "(+) Adds an extra round to a routine",
      position: 'left'
    },
    {
      element: '#wStep8',
      intro: "These options delete current step or round. You cannot delete your only step or round",
      position: 'right'
    },
    {
      element: '#FinishStep',
      intro: "This option stores the pads selected in the simulator as a step",
      position: 'top'
    },
    {
      element: '#FinishRoutineButton',
      intro: "This option saves the custom routine. Name and description will need to be provided afterwards. You are ready to start creating your own rotines!",
      position: 'top'
    }
    ]

  });
});

</script>