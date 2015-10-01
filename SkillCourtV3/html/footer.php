<?php date_default_timezone_set('America/New_York'); ?>

    <!-- Footer -->
    <footer>
        <div class="text-center footer-below">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <p>Copyright &copy; <?php echo date('Y'); ?> SkillCourt</p>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- JQuery Scripts -->
    <script>
        $(function () {
            $('#passwordModal').on('show.bs.modal', function (e) {
              $('#emailAddressForPasswordChange').val('');
            });

            $('#incompleteProfile').on('click', function (e) {
                $('a[href=#settings]').tab('show');
                if($('#lisettings').hasClass('active')){
                    $('#lihome').addClass('borderBottom');
                    $('#limessages').addClass('borderBottom');
                    $('#lisettings').removeClass('borderBottom');
                }
            });
            
            $('[data-toggle=tooltip]').tooltip();
            
            $('[data-toggle=popover]').popover({
                html: true, 
                content: function() {
                  return $('#popover-content').html();
                },
                viewport: '.container'
            });
        });
        

        $(document).ready(function(){
            var max_fields = 5;
            var wrapper = $(".input_fields_wrap");
            var add_button = $(".add_field_button");

            var x = 1;
            $(add_button).click(function(e){
                e.preventDefault();
                if(x < max_fields){
                    x++;
                    $(wrapper).append('<div class="col-xs-2"><input class="form-control" type="text" name="teams" title="Enter your favorite team" placeholder="Team name"/><a href="#" class="remove_field">Remove</a></div>');
                }
            });

            $(wrapper).on("click", ".remove_field", function(e){
                e.preventDefault();
                $(this).parent('div').remove();
                x--;
            });

            //How can I make this work?
            $.fn.borderBottom = function (x,y,z) {
                if($(x).hasClass('active')){
                    $(y).addClass('borderBottom');
                    $(z).addClass('borderBottom');
                    $(x).removeClass('borderBottom');
                }
            };

            //We do this when we the settings tab is clicked
            if($("#lihome").hasClass("active")){
                $('#limessages').addClass('borderBottom');
                $('#lisettings').addClass('borderBottom');  
                $('#lihome').removeClass('borderBottom');
            }
            
            //we do this when the settings link is clicked from the incomplete profile button
            if($('#lisettings').hasClass('active')){
                $('#lihome').addClass('borderBottom');
                $('#limessages').addClass('borderBottom');
                $('#lisettings').removeClass('borderBottom');
            }

            if($('#limessages').hasClass('active')){
                $('#lihome').addClass('borderBottom');
                $('#lisettings').addClass('borderBottom');
                $('#limessages').removeClass('borderBottom');
            }

            $('#ahome').on('click', function(){
                $('#limessages').addClass('borderBottom');
                $('#lisettings').addClass('borderBottom');
                $('#lihome').removeClass('borderBottom');
            });

            $('#asettings').on('click', function(){
                $('#limessages').addClass('borderBottom');
                $('#lihome').addClass('borderBottom');
                $('#lisettings').removeClass('borderBottom');
            });

            $('#amessages').on('click', function(){
                $('#lihome').addClass('borderBottom');
                $('#lisettings').addClass('borderBottom');
                $('#limessages').removeClass('borderBottom');
            });


        });
            



    </script>


      
</body>
</html>
