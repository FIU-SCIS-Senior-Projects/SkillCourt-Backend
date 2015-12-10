<?php
    
    include_once 'parseHeader.php';
    
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    
    $currentUser = ParseUser::getCurrentUser();
    
    try {
        //echo $currentUser->get('firstName');
        
        $firstName = $_POST['firstNameInput'];
        $lastName = $_POST['lastNameInput'];
        $middleName = $_POST['middleInitialInput'];
        $phone = $_POST['phoneInput'];
        $gender = $_POST['genderInput'];
        $position = $_POST['positionInput'];
        //$birthdate = $_POST['birthDateInput'];
        //echo $birthdate;
        
        /*$value = new DateTime();
        
        $dateFormatString = 'Y-m-d\TH:i:s.u';
        $date = date_format($value, $dateFormatString);
        $date = substr($date, 0, -3) . 'Z';
        echo $date;*/
        
        $dateFormatString = 'Y-m-d\TH:i:s.u';
        $date = DateTime::createFromFormat('j-M-Y', '15-Feb-2009');
        echo date_format($date,$dateFormatString);
        
        $currentUser->set("firstName",$firstName);
        $currentUser->set("lastName",$lastName);
        $currentUser->set("middleInitial",$middleName);
        $currentUser->set("phone",$phone);
        $currentUser->set("gender",$gender);
        $currentUser->set("position",$position);
        $currentUser->save();
        
        header('Location: profile.php');
    } catch (ParseException $error) {
        echo $error->getCode() . " " . $error->getMessage();
    }
    
?>