//=require_tree
$(function(){
  $('.sidenav li a').on('click', function(e){
    e.preventDefault();
    var $this= $(this);
    if ($this.hasClass('fa-google-plus')){
      $('div').filter(document.getElementsByClassName('gmail')).parent().toggleClass('on off');
    }

    if ($this.hasClass('fa-github')){
      $('div').filter(document.getElementsByClassName('github')).parent().toggleClass('on off');
    }

    if ($this.hasClass('fa-twitter')){
      $('div').filter(document.getElementsByClassName('twitter')).parent().toggleClass('on off');
    }

    if ($this.hasClass('fa-envelope')){
      $('div').filter(document.getElementsByClassName('outlook')).parent().toggleClass('on off');
    }

  });
});
