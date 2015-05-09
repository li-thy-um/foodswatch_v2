$(function(){
  init_modal('.food-tag', 'food');
  init_modal('.btn-share', 'share');
});

init_modal = function(trigger, name){
  $("body").on('click', trigger, function(){
    var id = $(this).data('id');
    $.get('/modals/'+name+'/'+id, function(data){
      $('#'+name+'_modal').remove();
      $('body').append(data);
      $('#'+name+'_modal').modal('show');
    });
  });
};
