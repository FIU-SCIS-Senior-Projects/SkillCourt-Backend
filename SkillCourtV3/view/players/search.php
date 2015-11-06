<div class="container">
  <div class="row">    
    <div class="col-xs-8 col-xs-offset-2">
      <form action="index.php?show=players&controller=players&action=index">
        <div class="input-group">
          <div class="input-group-btn search-panel">
            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
              <span id="search_concept">Filter by</span> <span class="caret"></span>
            </button>
                    
            <ul class="dropdown-menu" role="menu">
              <li><a href="#lastname">Last Name</a></li>
              <li><a href="#firstname">First Name</a></li>
              <li><a href="#username">Username</a></li>
              <li><a href="#email">Email</a></li>
              <li><a href="#position">Position</a></li>
            </ul>
          </div>
          
          <input type="hidden" name="show" value="players" id="search_param1">         
          <input type="hidden" name="controller" value="players" id="search_param2"> 
          <input type="hidden" name="action" value="show" id="search_param3">         
       

          <input type="hidden" name="search_param" value="username" id="search_param">         
          <input type="text" class="form-control" name="x" placeholder="Search Player..." required>
          <span class="input-group-btn">
            <button class="btn btn-default" type="submit">Search</i></button>
          </span>
        </div>
      </form>
    </div>
  </div>
</div>