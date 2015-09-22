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
    
    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="./js/bootstrap.min.js"></script>

    <!-- JQuery Scripts -->
    <script>
        $(function () {
            $('#passwordModal').on('show.bs.modal', function (e) {
              $('#emailAddressForPasswordChange').val('');
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

        
    </script>


      
</body>
</html>
