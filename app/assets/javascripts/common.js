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

Turbolinks.enableProgressBar();
