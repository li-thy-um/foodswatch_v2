include ApplicationHelper

class PageInfo
  attr_reader :name, :title, :content
  def initialize(name, title, content)
    @name, @title, @content = name, full_title(title), content
  end
end

def layout_links
  pages = static_pages.merge(user_pages)
  { "About"        => pages[:about_path],
    "Help"         => pages[:help_path],
    "Contact"      => pages[:contact_path],
    "Home"         => pages[:root_path],
    "Sign up now!" => pages[:signup_path], 
    "sample app"   => pages[:root_path] }
end

def static_pages
  { root_path:    PageInfo.new("Home page",    "",         "Sample App"),
    help_path:    PageInfo.new("Help page",    "Help",     "Help"),
    about_path:   PageInfo.new("About page",   "About Us", "About Us"), 
    contact_path: PageInfo.new("Contact page", "Contact",  "Contact") }
end

def user_pages
  { signup_path: PageInfo.new("Sign up page", "Sign up", "Sign up") }
end
