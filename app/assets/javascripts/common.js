$(function(){
  only_one_popover();
  init_btn_submit();
});

function init_btn_submit(){
  $("body").delegate('.btn-submit', 'click', function(){
    // var $form = $("#"+$(this).attr("form-id"));
    var $textarea =$("#"+$(this).attr("textarea-id"));
    // $form.submit();
    clear_form($textarea);
  });
}

function only_one_popover(){
  $('body').delegate(".popovers", "click", function(){
    var count = $(".popover").size();
    var $thiz = $(this);
    if (count > 1){
       $(".popover").first().remove();
    }
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

function last_word_of(string){
  return string.split("_").pop();
}
