
$(document).on('ready', function(){
  var timer = setInterval(function(){
    $('#refreshBtn').on('click', function(event){

      $.ajax({
        url: 'https://api.twitter.com/1.1/search/tweets.json?q=%23freebandnames&since_id=24012619984051000&max_id=250126199840518145&result_type=mixed&count=4',
        method: 'GET',
        dataType: 'json',
        data: { take: 7 },
      }).done(function(data){
        console.log(data);
      })
    });
  }, 1200);
});
