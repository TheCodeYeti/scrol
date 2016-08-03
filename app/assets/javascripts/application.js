// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function(){

  // Ajax request for the login form onclick


  $('.login_form_reload a').on('click', (function() {
    /* Act on the event */

  //   $.ajax({
  //     url: $(this).attr('href'),
  //     type: 'GET',
  //     dataType: 'html',
  //     data: {}
  //   })
  //   .done(function() {
  //     console.log("success");
  //   })
  //   .fail(function() {
  //     console.log("error");
  //   })
  //   .always(function() {
  //     console.log("complete");
  //   });
  //
  //
  // });
  //***************************************************************//
  //***************************************************************//

  $('.sidenav').on('mouseover', function(){
    // e.preventDefault()
    $('.sidenav').addClass('open');

  });

  $('.sidenav').on('mouseout', function(){
    $('.sidenav').removeClass('open');
  });

  //These are the navigation links
  /******
    render content on click on the home page
    Using ajax calls to get data from the database
  */

  $('.user-icon').on('click', function(event){
    alert("This is also working !!!")
    event.preventDefault()

    $.ajax({
      url: $(this).attr('href'),
      method: 'GET',
      data: {},
      dataType: 'html'
    }).done(function(responseData){
      // 4. take the response from the server and render it on console
      console.log(responseData);
    })
  });

  $('.google-plus').on('click', function(event){
     alert("This is working!!")
     event.preventDefault()

     $.ajax({
       url: $(this).attr('href'),
       method: 'GET',
       data: {},
       dataType: 'html'
     }).done(function(responseData){
       console.log(responseData);
     })
  });

  $('.youtube').on('click', function(){
    alert("This can also be working hey!!!")
  });

  $('.twitter').on('click', function(){
    alert("This happens to be working!!")
  });

  $('.facebook').on('click', function(){
    alert("This happens to be working!!")
  });

  $('.instagram').on('click', function(){
    alert("This happens to be working!!")
  });

});
