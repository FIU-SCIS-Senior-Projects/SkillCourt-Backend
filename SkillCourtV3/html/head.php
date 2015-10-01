<html>
<head>
    <?php include('./inc/headerCode.php'); ?>
</head>
<body>

    <?php include('./inc/navbar.php'); ?>    

    <!-- Banner -->
    <div class="container" id="bannerImg">
        <div class="row">
            <div class="col-md-12">
                <h1 class="text-center whiteHeaders">Welcome to SkillCourt </h1>
            </div>
        </div>
    </div>

    
    <!-- Social Media / Registration link  -->
    <div class="container" id="socialBanner"> 
        <ul class="list-inline" id="socialIcons">
            <li>
                <a href="#" class="btn-social btn-outline"><i class="fa fa-fw fa-facebook"></i></a>
            </li>
            <li>
                <a href="#" class="btn-social btn-outline"><i class="fa fa-fw fa-google-plus"></i></a>
            </li>
            <li>
                <a href="#" class="btn-social btn-outline"><i class="fa fa-fw fa-twitter"></i></a>
            </li>
            <li>
                <a href="#" class="btn-social btn-outline"><i class="fa fa-fw fa-instagram"></i></a>
            </li>
            <li>
                <a href="#" class="btn-social btn-outline"><i class="fa fa-fw fa-linkedin"></i></a>
            </li>
        </ul>

        <!-- Registration logic -->
        <?php if(!$currentUser): ?>
            <button type="button" class="btn btn-link" id="registerLink" data-placement="bottom" data-toggle="popover" data-title="Register" data-container="body" data-html="true">Click here to Register</button>
            <div class="hide" id="popover-content">
                
                <form action="javascript:validatePartialSignUp();" name="create_form">
                    <div class="form-group">
                        <label for="InputUsername">Username</label>
                        <input type="text" class="form-control" id="createUsernameInput" name="createUsernameInput" placeholder="Username" required>
                    </div>
                    <div class="form-group">
                        <label for="InputPassword">Password</label>
                        <input type="password" class="form-control" id="createPasswordInput" name="createPasswordInput" placeholder="Password" required>
                    </div>
                    <div class="form-group">
                        <label for="InputConfirmPassword"> Confirm-Password</label>
                        <input type="password" class="form-control" id="confirmPasswordInput" name="confirmPasswordInput" placeholder="Confirm Password" onkeyup="javascript:checkPass(); return false;" required>
                        <span id="confirmMessage" class="confirmMessage"></span>
                    </div>
                    <div class="form-group">
                        <label for="InputEmail">Email Address</label>
                        <input type="email" class="form-control" id="createEmailInput" name="createEmailInput" placeholder="Email" required>
                    </div>
                    <button type="reset" class="btn btn-default" id="clearSignUpForm">Clear</button>
                    <button type="submit" class="btn btn-default" id="createPlayerButton">Submit</button>

                </form>

            </div>
        <?php endif ?>
    </div> 
