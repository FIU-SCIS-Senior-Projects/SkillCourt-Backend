<?php 
  /**
  * 
  */
  class PagesController
  {
    public function home()
    {
      //Any Variables we are going to use to show in the view
      $firstName = "Will";
      $lastName = "Rodriguez";
      require_once('view/pages/home.php');
    } 

    public function error()
    {
      require_once('view/pages/error.php');
    } 

    public function routinesHome()
    {
      require_once('view/pages/routinesHome.php');
    }
  }

?>
