<?php
    
    include_once 'parseHeader.php';
    
    use Parse\ParseUser;
    use Parse\ParseObject;
    use Parse\ParseException;
    
    
    if (isset($_POST['emailAddressForPasswordChange']))
        try {
            ParseUser::requestPasswordReset($_POST['emailAddressForPasswordChange']);
            header('Location: ./index.php');
            // Password reset request was sent successfully
        } catch (ParseException $ex) {
            // Password reset failed, check the exception message
        }
?>
