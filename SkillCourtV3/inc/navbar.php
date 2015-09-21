<?php
    $username = $currentUser->getUsername();
    $isCoach = $currentUser->get("isCoach");
    echo $isCoach;
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
            <a class="navbar-brand" href="#">SkillCourt &copy;</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-left">
                <?php if ($currentUser) : ?>
                    <!-- Links for the active user -->
                    <li class="active"><a href="../html/main.php">Home</a></li>
                    <li><a href="#about">About</a></li>
                    <li><a href="#contact">Help</a></li>
                <?php else: ?>
                    <!-- Just in case -->
                    <li class="active"><a href="../html/main.php">Home</a></li>
                <?php endif?>                
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <?php if($isCoach): ?> 
                    <!-- This is the coach -->
                    <li><a href="#contact">Routines</a></li>
                    <li><a href="#contact">Wizards</a></li>
                    <li><a href="#contact">Players</a></li>
                    <li><a href="#contact"><?php echo $username ?></a></li>
                    <li>
                        <button type="button" class="btn btn-link btn-lg topBannerIconUser" data-toggle="tooltip" data-placement="bottom" title="Logout" onclick="location.href = '../inc/logout.php';">
                            <span class="glyphicon glyphicon glyphicon glyphicon-log-out" aria-hidden="true"></span>
                        </button>
                    </li>
                <?php else: ?>
                    <!-- This is the player -->
                    <li><a href="#contact">Routines</a></li>
                    <li><a href="#contact">Simulator</a></li>
                    <li><a href="#contact"><?php echo $username ?></a></li>
                    <li>
                        <button type="button" class="btn btn-link btn-lg topBannerIconUser" data-toggle="tooltip" data-placement="bottom" title="Logout" onclick="location.href = '../inc/logout.php';">
                            <span class="glyphicon glyphicon glyphicon glyphicon-log-out" aria-hidden="true"></span>
                        </button>
                    </li>
                <?php endif?>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav> <!-- end of navabar -->
