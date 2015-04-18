$(init_microposts);

function init_microposts(){
  $("body").delegate('.div-click', 'click', function(){
    var $div = $(this);
    $div.next().collapse('toggle'); 
    $div.next().next().toggleClass('hidden')
  });
}
