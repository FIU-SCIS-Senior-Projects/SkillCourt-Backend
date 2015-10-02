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
            <a class="navbar-brand" href="index.php">SkillCourt &copy;</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-left">
                <li id="homeli" <?php echo (isset($_GET["show"]) && $_GET["show"] == "home") ? 'class=active' : ''; ?> ><a id="home" href="index.php?show=home">Home</a></li>
                <li id="aboutli"<?php echo (isset($_GET["show"]) && $_GET["show"] == "about") ? 'class=active' : ''; ?>><a id="about" href="index.php?show=about">About</a></li>
                <li id="helpli" <?php echo (isset($_GET["show"]) && $_GET["show"] == "help") ? 'class=active' : ''; ?>><a id="help" href="index.php?show=help">Help</a></li>
            </ul>
            <?php if($userNotLogged) : ?>
                <!-- Login Form -->
                <form class="navbar-form navbar-right" action="./inc/process_login.php" method="POST" name="login_form">
                    <div class="form-group">
                        <input type="text" class="form-control input-sm" name="username" placeholder="Username" id="username" required>
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control input-sm" name="password" placeholder="Password" id="password" required>
                    </div>
                    <button type="submit" class="btn btn-link btn-lg topBannerIcon" data-toggle="tooltip" data-placement="bottom" title="Login">
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
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "wizards") ? 'class=active' : ''; ?>><a href="index.php?show=wizards">Wizards</a></li>
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "players") ? 'class=active' : ''; ?>><a href="index.php?show=players">Players</a></li>
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "profile") ? 'class=active' : ''; ?>><a href="index.php?show=profile">Welcome <?php echo $username ?></a></li>
                    <li>
                        <button type="button" class="btn btn-link btn-lg topBannerIconUser" data-toggle="tooltip" data-placement="bottom" title="Logout" onclick="location.href = './inc/logout.php';">
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
                        <button type="button" class="btn btn-link btn-lg topBannerIconUser" data-toggle="tooltip" data-placement="bottom" title="Logout" onclick="location.href = './inc/logout.php';">
                            <span class="glyphicon glyphicon glyphicon glyphicon-log-out" aria-hidden="true"></span>
                        </button>
                    </li>
                </ul>
            <?php endif?>
            <?php if(!$isCoach && !$isPlayer && !$userNotLogged): ?>
                <ul class="nav navbar-nav navbar-right">
                    <li <?php echo (isset($_GET["show"]) && $_GET["show"] == "profile") ? 'class=active' : ''; ?>><a href="index.php?show=profile">Welcome <?php echo $username ?></a></li>
                    <li>
                        <button type="button" class="btn btn-link btn-lg topBannerIconUser" data-toggle="tooltip" data-placement="bottom" title="Logout" onclick="location.href = './inc/logout.php';">
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

                <form action="./inc/resetPassword.php" method="POST" name="change_password_form">    
                    <div class="form-group">
                        <label for="exampleInputEmail1">Email address</label>
                        <input class="form-control" placeholder="Enter email" type="email" name="emailAddressForPasswordChange" id="emailAddressForPasswordChange" required>
                    </div>
                    <button class="btn btn-primary" type="submit" name="submitPasswordChange" value="SEND">Submit</button>                    
                </form>
                
            </div>
            
            <div class="modal-footer">
                <button class="btn btn-primary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>