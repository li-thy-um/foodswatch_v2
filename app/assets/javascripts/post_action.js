$(function(){
  $(document).on('click', '.btn-foods', function(){
    $('.add-food-panel').fadeToggle(init_add_food_modal);
  });
});

var init_add_food_modal = function(){
  $(".watch-list-typeahead").typeahead({
    source: function(query, process){
      get_watch_list(query, process);
    },

    highlighter: function(food_info){
      return make_food(food_info).name;
    },

    updater: function(food_info) {
      var food = make_food(food_info); //food_info is a string.
      add_food(food);
    }
  });

  $("#create_food_btn").click(add_food);

  var $form = $("#new_food_form");
  $form.children(".name").
    keypress(toggle_create_food_btn).
    keyup(toggle_create_food_btn).
    keypress();
};

var get_watch_list = function(query, process){
  $.get( '/foods/query', { current_user: true, query: query },
    function(data){
      process(data.split(","));
    });
};

var make_food = function(food_info /* like "id_name" */){
  var info_array = food_info.split("_");
  return {
    id: info_array[0],
    name: info_array[1]
  };
};

var toggle_create_food_btn = function(){
  attach_toggle($("#create_food_btn"), $(this));
};

var attach_toggle = function($btn, $input){
  var str = $input.val() || "";
  if ($.trim(str) == ""){
    disable($btn);
  }else{
    enable($btn);
  }
};

var add_food = function(food){
  if (count_food() > 9){
    alert("哎呀你一次吃的太多啦 (>_<|||)");
    return;
  }
  add_hidden_input(food); //do this before add_label.
  add_label(food);
  if (!food.id){
    clear($("#new_food_form"));
  }
};

var delete_food = function() {
  var $label = $(this);
  var id = $label.attr("group-id");
  $("#food_form").children(".group_" + id).each(function(i,e){
    $(e).remove();
  });
  $label.fadeOut({complete: function(){
    this.remove();
  }});
};

var add_label = function(food){
  var name = "";
  if (food && food.name){
    name = food.name;
  }else{
    name = $("#new_food_form").find(".name").val();
  }
  var $label = $("#label_sample").children().first().clone().append(name+" ");
  $label.attr("group-id", count_food()).click(delete_food);
  $label.attr("style", "margin-right:2px;")
  $("#choosed").fadeIn().append($label.hide().fadeIn());
};

var add_hidden_input = function(food){
  var $food_form = $("#food_form");
  if(food && food.id){
    var $input = $("#food_id_input_sample").children().first().clone();
    append_input($food_form, $input, food.id);
  }else{
    var $food_sample = $("#new_food_form");
    $food_sample.children("input").each(function(i,e){
      var $input = $(e).clone();
      var value = $input.val();
      if (value == "") value = 0; //default value for nutri
      append_input($food_form, $input, value);
    });
  }
};

var append_input = function($form, $input, value){
  $input.attr("value", value);
  $input.addClass("group_" + count_food());
  $form.append($input);
};

var count_food = function(){
  return $("#choosed").find(".click-del").length;
};
