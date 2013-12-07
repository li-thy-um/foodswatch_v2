include ApplicationHelper

class PageInfo
  attr_reader :name, :title, :content
  def initialize(name, title, content, option = { full_title: true })
    @name, @content = name, content
    if option[:full_title] == true
      @title = full_title(title)
    else
      @title = title
    end
  end
end

class UserPageInfo < PageInfo
  attr_reader :user
  def initialize(name, title, content, option = { full_title: true },
                 user = nil)
    super(name, title, content, option)
    @user = user
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

USER = FactoryGirl.create(:user)
def user_pages
  { signup_path:         UserPageInfo.new("Sign up page", "Sign up", "Sign up"),
    "user_path(user)" => UserPageInfo.new("Profile page", USER.name, USER.name,
                                          { full_title: false }, USER) }
end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password 
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text:message)
  end
end
