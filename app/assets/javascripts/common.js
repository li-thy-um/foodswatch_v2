$(function(){
  click_other_hide_popover();
})

function click_other_hide_popover(){
  $body = $("body :not(.popover)");
    //TODO have some question here.
  
  $body.find('.popovers').each(function(){
    $(this).click(function(e){
      $('.popover').remove();
      e.preventDefault();
      return false;
    });
  });

  $body.click(function(){
    $('.popover').remove();
  });
}

function clear($form) {
  $form.children("input").each(function(i,e){
    $(e).val("");
  });
}

function disable($btn) {
  $btn.attr("disabled","disabled");
  $btn.addClass("disabled");
}

function enable($btn){
  $btn.removeAttr("disabled");
  $btn.removeClass("disabled");
}
