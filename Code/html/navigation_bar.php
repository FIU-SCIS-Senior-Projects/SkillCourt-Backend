<?php
    $username = $currentUser->getUsername();
    $isCoach = $currentUser->get("isCoach");
    echo $isCoach;
?>

<div id="navigationBar">
        <div class="navigationButtons" id="buttonGroup">
            <button id="homeButton" onclick="location.href = 'Main.php';">Home</button>
            <?php if ($isCoach):?>

            <?php else:?>
                <button id="routineButton" onclick="location.href = 'routines.php';">Routines</button>
                <button id="simulatorButton" onclick="location.href = 'simulator.php'; ">Simulator</button>
                <button id="usernameButton"><?php echo $username ?></button>
            <?php endif?>
		</div>
</div>
