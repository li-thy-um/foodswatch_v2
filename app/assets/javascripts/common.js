$(function(){
  click_other_hide_popover();
  init_btn_submit();
});

function init_btn_submit(selector){
  selector = selector || ".btn-submit";
  $(selector).click(function(){
    var form_id = $(this).attr("form-id");
    $("#"+form_id).submit();
  }) 
}

function click_other_hide_popover($btn){
  $body = $("body :not(.popover)");
    //TODO have some question here.
  var flag = false;

  if ($btn == undefined){
    $btn = $body.find('.popovers');
    var flag = true;
  }
  
  $btn.each(function(){
    $(this).click(function(e){
      $('.popover').remove();
      e.preventDefault();
      return false;
    });
  });

  if (flag){
    $body.click(function(){
      $('.popover').remove();
    });
  }
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

function last_word_of(string){
  return string.split("_").pop();
}
