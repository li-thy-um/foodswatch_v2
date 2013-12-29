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

def user_with_microposts
  user = FactoryGirl.create(:user)
  prepare_microposts_for(user)
end

def prepare_microposts_for(user)
  50.times do
    FactoryGirl.create(:micropost, user: user)
  end
  user
end

def sign_in(user, options = {})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(
      :remember_token, User.encrypt(remember_token))
  else
    if block_given?
      yield user
    else
      visit signin_path
    end
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password 
    click_button "Sign in"
  end
end

def sign_out
  delete signout_path
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text:message)
  end
end
