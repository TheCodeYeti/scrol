
 $(function(){


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


   ('fa-google-plus').on('click', function(e){
     e.preventDefault();
     if ($('gmail-item').hasClass('on')){
       $('gmail-item').removeClass('on');
       $('gmail-item').fadeOut(200).addClass('off');
     } else {
       $('gmail-item').removeClass('off');
       $('gmail-item').fadeIn(200).addClass('on')

     }
   })
 });
