module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 60, :class => "" })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    image_tag(user.avatar_url || gravatar_url, alt: user.name, class: "gravatar #{options[:class]}", style: "height:#{size}px;width:#{size}px")
  end

  def gravatar_for_nav(user, options = { size: 60 })
    options[:class] ||= "img-thumbnail"
    gravatar_for user, options
  end

  def user_link(user)
    link_to("@" + user.name, user)
  end
end
