module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 60, :class => "" })
    size = options[:size]
    image_tag(avatar_url(user), alt: user.name, class: "gravatar #{options[:class]}", height: size, width: size)
  end

  def gravatar_for_nav(user, options = { size: 60 })
    options[:class] ||= "img-thumbnail"
    gravatar_for user, options
  end

  def avatar_url(user)
    user.avatar_url || gravatar_url(user)
  end

  def gravatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png"
  end

  def user_link(user)
    link_to("@" + user.name, user)
  end
end
