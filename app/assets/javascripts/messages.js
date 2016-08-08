$(function(){
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
