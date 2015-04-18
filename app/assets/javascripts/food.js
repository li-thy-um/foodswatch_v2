$(init_food_tag);

function init_food_tag(){
  $("body").delegate('.food-tag', 'click', function(){
    var $tag = $(this);
    var tag_id = $tag.attr('tag-id');
    var init = $tag.hasClass('initialed');
    if (!init){
      set_food_tag({
        title: function(){
          return $("#popover_head_"+tag_id).html();
        },
        content: function(){
          return $("#popover_content_"+tag_id).html();
        },
        $target: $tag
      });
      $tag.addClass('initialed');
      $tag.click();
    }
  });
}

function set_food_tag(option){
  option.$target.popover({
    container: "body",
    html: true,
    title: option.title,
    content: option.content
  });
}
