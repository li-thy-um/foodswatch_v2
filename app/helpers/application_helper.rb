module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Foods Watch"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def unique_id
    Time.now.to_f.to_s.split(".").join("")
  end

  def trim(str)
    str.strip
  end
end
