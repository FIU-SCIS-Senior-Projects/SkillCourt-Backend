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
              <li><a href="#position" id="positionPicker">Position</a></li>
            </ul>
          </div>
          
          <div class="hide" id="positionDowndownDiv">
            <select class="form-control" id="positionDropdown" name="positionDropdown" >
              <option value=""></option>
              <option value="Goalkeeper">Goalkeeper</option>
              <option value="Center-Back">Center-Back</option>
              <option value="Left-Back">Left-Back</option>
              <option value="Right-Back">Right-Back</option>
              <option value="Left Wing Back">Left Wing Back</option>
              <option value="Right Wing Back">Right Wing Back</option>
              <option value="Defending Midfielder">Defending Midfielder</option>
              <option value="Central Midfielder">Central Midfielder</option>
              <option value="Attacking Midfielder">Attacking Midfielder</option>
              <option value="Left Wing">Left Wing</option>
              <option value="Right Wing">Right Wing</option>
              <option value="Withdrawn Striker">Withdrawn Striker</option>
              <option value="Striker">Striker</option>
            </select>
          </div>
          
          <input type="hidden" name="show" value="players" id="search_param1">         
          <input type="hidden" name="controller" value="players" id="search_param2"> 
          <input type="hidden" name="action" value="recruit" id="search_param3">         
       

          <input type="hidden" name="search_param" value="username" id="search_param">         
          <input type="text" class="form-control" id="inputSearch" name="x" placeholder="Search Player..." required>
          <span class="input-group-btn">
            <button class="btn btn-default" type="submit">Search</i></button>
          </span>
        </div>
      </form>
    </div>
  </div>
</div>