module ApplicationHelper

  def has_more_page?(records)
    records.current_page.to_i < records.total_pages
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Foods Watch"
    if page_title.empty?
      base_title
    else
      "#{page_title}-#{base_title}"
    end
  end

  def js_render(view, locals)
    escape_javascript( render view, locals )
  end

  # Return the first error message of the model. If no error, return ''.
  def error_message_for(model)
    msg = model.errors.messages
    if msg.empty?
      ''
    else
      msg.values.flatten.first
    end
  end
end
