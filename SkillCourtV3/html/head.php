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
                <h1 class="text-center">Welcome to SkillCourt </h1>
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
                <a href="#" class="btn-social btn-outline"><i class="fa fa-fw fa-linkedin"></i></a>
            </li>
        </ul>
        <?php if(!$currentUser): ?>
            <button type="button" class="btn btn-link" id="registerLink" data-placement="bottom" data-toggle="popover" data-title="Register" data-container="body" data-html="true">Click here to Register</button>
            <div class="hide" id="popover-content">
                <form class="form-inline" role="form">
                    <div class="form-group">
                        <input type="text" placeholder="Name" class="form-control" maxlength="5">
                    </div>
                    <button type="submit" class="btn btn-primary">Go To Login »</button>
                </form>
            </div>
        <?php endif ?>
    </div> 
