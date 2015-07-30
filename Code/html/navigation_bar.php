<?php
    $username = $currentUser->getUsername();
    $isCoach = $currentUser->get("isCoach");
    echo $isCoach;
?>
<div><img src="style/images/soccer2.jpg" id="bg" alt=""></div>
<div id="navigationBar">
        <div class="navigationButtons" id="buttonGroup">
            <button id="homeButton" onclick="location.href = 'Main.php';">Home</button>

            <?php if ($currentUser) : ?>
                <button id="text" onclick="location.href = 'Main.php';">SkillCourt</button>
            <?php else:?>
                <button id="text" onclick="location.href = 'index.php';">SkillCourt</button>
            <?php endif ?>

            <?php if ($isCoach):?>
				<button id="routineButton" onclick="location.href = 'coachRoutines.php';">Routines</button>
                <button id="simulatorButton" onclick="location.href = 'customWizard.php'; ">Wizard</button>
                <button id="playerButton" onclick="location.href = 'managePlayers.php';">Players</button>
                <button id="usernameButton" onclick="location.href = 'profile.php';"><?php echo $username ?></button>
           
            <?php else:?>
                <button id="routineButton" onclick="location.href = 'routines.php';">Routines</button>
                <button id="simulatorButton" onclick="location.href = 'simulator.php'; ">Simulator</button>
                <button id="usernameButton" onclick="location.href = 'profile.php';"><?php echo $username ?></button>
            <?php endif?>
		</div>
        <button id="logInButton" onclick="location.href = 'logout.php';">Log Out</button>
</div>
<footer id="pageFooter"></footer>