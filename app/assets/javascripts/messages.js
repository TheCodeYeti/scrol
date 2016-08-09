
 $(function(){


  var load = $(".refreshBtn").on('click', function(event){
     event.preventDefault()

         $.ajax({
           url: 'messages',
           type: 'GET',
           dataType: 'json',
           data: {}
         })
         .done(function(data) {

               $('.container').append( data );

         })
         .fail(function() {
           console.log("error");
         })
         .always(function() {
           console.log("complete");
         });

   });






   $('fa-google-plus').on('click', function(e){
     e.preventDefault();
     if ($('gmail-item').hasClass('on')){
       $('gmail-item').removeClass('on');
       $('gmail-item').fadeOut(200).addClass('off');
     } else {
       $('gmail-item').removeClass('off');
       $('gmail-item').fadeIn(200).addClass('on')

     }
   });
 });
