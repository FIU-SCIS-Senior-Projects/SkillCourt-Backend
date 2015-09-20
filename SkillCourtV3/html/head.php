<html>
<head>
    <title><?php echo $pageTitle; ?></title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Soccer Training - SkillCourt">
    <meta name="author" content="Will Rodriguez, Sergio Saucedo">

    <!-- Bootstrap Core CSS -->
    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
    
    <!-- Custom CSS -->
    <link href="../css/skillcourt.css" rel="stylesheet" type="text/css">

    <!-- Custom Fonts -->
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

</head>
<body>

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
                    <li class="active"><a href="#">Home</a></li>
                    <li><a href="#about">About</a></li>
                    <li><a href="#contact">Help</a></li>
                </ul>
                <!-- Login Form -->
                <form class="navbar-form navbar-right" role="search">
                    <div class="form-group">
                        <input type="text" class="form-control input-sm" name="username" placeholder="Username">
                    </div>
                    <div class="form-group">
                        <input type="text" class="form-control input-sm" name="password" placeholder="Password">
                    </div>
                    <button type="submit" class="btn btn-default btn-sm">Sign In</button>
                </form>
            </div><!--/.nav-collapse -->
        </div>
    </nav>

    <!-- Banner -->
    <div class="container" id="bannerImg">
        <div class="row bannerText">
            <div class="col-md-12">
                <h1 class="text-center">Welcome to SkillCourt </h1>
            </div>
        </div>
    </div>

    <!-- Social Media / Registration link  -->
    <div class="container" id="socialBanner"> 
        <button type="button" class="btn btn-link" id="registerLink">Click here to Register</button>
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
    </div> 
