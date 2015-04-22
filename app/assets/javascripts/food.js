$(init_food_tag);

function init_food_tag(){
  $("body").delegate('.food-tag', 'click', function(){
    var id = $(this).data('id');
    $.get('/foods/'+id, function(data){
      $('#food_modal').remove();
      $('body').append(data);
      $('#food_modal').modal('show');
    });
  });
}
