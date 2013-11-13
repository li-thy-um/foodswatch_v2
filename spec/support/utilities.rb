class PageInfo
  attr_reader :name, :title, :content
  def initialize(name, title, content)
    @name, @title, @content = name, full_title(title), content
  end
  
  private
  
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end

def static_pages
  {root_path: PageInfo.new("Home page", "", "Sample App"),
   help_path: PageInfo.new("Help page", "Help", "Help"),
   about_path: PageInfo.new("About page", "About Us", "About Us"), 
   contact_path: PageInfo.new("Contact page", "Contact", "Contact")}
end

def user_pages
  {signup_path: PageInfo.new("Sign up page", "Sign up", "Sign up")}
end
