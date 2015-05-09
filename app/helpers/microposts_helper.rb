module MicropostsHelper

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  def post_div_id(id, page)
    if page == 'share'
      "share_#{id}"
    else
      id
    end
  end

  def timestamp_for(micropost)
    micropost.created_at.localtime("+08:00").strftime('%-m月%-d日 %R')
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
    end
end
