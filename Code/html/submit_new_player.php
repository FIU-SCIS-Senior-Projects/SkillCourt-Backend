<?php
    
    include_once 'parseHeader.php';
    
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    use Parse\ParseCloud;
    
    $firstName = $_POST['createFirstNameInput'];
    $lastName = $_POST['createLastNameInput'];
    $middleName = $_POST['createMiddleNameInput'];
    $phone = $_POST['createPhoneInput'];
    $gender = $_POST['createGenderInput'];
    $position = $_POST['createPositionInput'];
    $birthdate = $_POST['createBirthdateInput'];
    $username = $_POST['createUsernameInput'];
    $password = $_POST['createPasswordInput'];
    $email = $_POST['createEmailInput'];
    $coach;
    
    if (isset($_POST['createCoachInput']))
    {
        echo $coach;
        $coach = TRUE;
        
    } else {
        $coach = FALSE;
    }
    
    $query = ParseUser::query();
    $query->equalTo("username", $username);
    $results = $query->find();
    
    if (!count($results))
    {
        $user = new ParseUser();
        $user->set("firstName",$firstName);
        $user->set("lastName",$lastName);
        $user->set("middleInitial",$middleName);
        $user->set("phone",$phone);
        $user->set("gender",$gender);
        $user->set("position",$position);
        $user->set("birthdate",$birthdate);
        $user->set("username",$username);
        $user->set("password",$password);
        $user->set("email",$email);
        $user->set("isCoach",$coach);
        
        try {
            $user->signUp();
            header('Location: index.php');
            // Hooray! Let them use the app now.
        } catch (ParseException $ex) {
            // Show the error message somewhere and let the user try again.
            echo "Error: " . $ex->getCode() . " " . $ex->getMessage();
        }
        
    } else {
        echo "Credentials already exists";
    }
    
    echo $firstName . " " . $username;
    
?>