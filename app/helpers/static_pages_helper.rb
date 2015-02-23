module StaticPagesHelper

  def flash_messages(key, value)
    content_tag(:div, value, class: "alert alert-#{key}")
  end

end
