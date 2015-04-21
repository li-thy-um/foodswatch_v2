$(function(){
  only_one_popover();
});

var $flash_message = function( type, msg ){
    $("#flash_area").append(
        '<div class="hide alert alert-'+type+'">'
        +'<strong>'+msg+'<strong></div>');
    var $flash = $("#flash_area").find("div:last");
    $flash.slideDown();
    setTimeout(function() {
        $flash.slideUp({
            complete: function(){
                $flash.remove();
            }
        });
    },5000);
};

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
