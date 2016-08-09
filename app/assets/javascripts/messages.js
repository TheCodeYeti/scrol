//=require_tree
$(function(){
  $('.sidenav li a').on('click', function(e){
    e.preventDefault();
    var $this= $(this);
    if ($this.hasClass('fa-google-plus')){
      $('div').filter(document.getElementsByClassName('gmail')).parent().toggleClass('on off', 1000, 'swing');
    }

    if ($this.hasClass('fa-github')){
      $('div').filter(document.getElementsByClassName('github')).parent().toggleClass('on off', 1000, 'swing');
    }

    if ($this.hasClass('fa-twitter')){
      $('div').filter(document.getElementsByClassName('twitter')).parent().toggleClass('on off', 1000, 'swing');
    }

    if ($this.hasClass('fa-envelope')){
      $('div').filter(document.getElementsByClassName('outlook')).parent().toggleClass('on off', 1000, 'swing');
    }

  });
  $(window).scroll( function(){

        /* Check the location of each desired element */

            var bottom_of_object = $(this).offset().top + $(this).outerHeight();
            var bottom_of_window = $(window).scrollTop() + $(window).height();

            /* If the object is completely visible in the window, fade it it */
            if( bottom_of_window > bottom_of_object ){

                $(this).animate({'opacity':'1'},500);

            }

});
