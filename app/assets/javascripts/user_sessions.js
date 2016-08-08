$(function(){ 
  $(".close").on("click", function() {
    $(".modal-login").fadeOut(500, "swing")
  });
  $(".login-btn").on("click", function(e) {
     e.preventDefault(),
     $(".modal-login").fadeIn(500, "swing")
  });

  $('.login-form').find('input, textarea').on('keyup blur focus', function (e) {

  var $this = $(this),
      label = $this.prev('label');

	  if (e.type === 'keyup') {
			if ($this.val() === '') {
          label.removeClass('active highlight');
        } else {
          label.addClass('active highlight');
        }
    } else if (e.type === 'blur') {
    	if( $this.val() === '' ) {
    		label.removeClass('active highlight');
			} else {
		    label.removeClass('highlight');
			}
    } else if (e.type === 'focus') {

      if( $this.val() === '' ) {
    		label.addClass('highlight active');
			}
      else if( $this.val() !== '' ) {
		    label.addClass('highlight');
			}
    }

  });

  $('.tab a').on('click', function(clickEvent){
    clickEvent.preventDefault();
    $(this).parent().addClass('active');
    $(this).parent().siblings().removeClass('active');

    target = $(this).attr('href');

    $('.tab-content > div').not(target).hide();
    $(target).fadeIn(600);
  });

});
