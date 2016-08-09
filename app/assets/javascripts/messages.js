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
  
  $('.refreshBtn').on('click', function(event){
    event.preventDefault()

    $.ajax({
      url: 'messages/import/1',
      type: 'GET',
      dataType: 'html',
      data: { params: 'refresh' }
    })
    .done(function(data) {
      console.log( 200, { "Content-Type": "text/html" }, data );
    })
    .fail(function() {
      console.log("error");
    })
    .always(function() {
      console.log("complete");
    });

  });
});
