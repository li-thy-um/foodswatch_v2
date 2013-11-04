require 'spec_helper'
 
def page_info(name, title, content)
  default_title = "Ruby on Rails Tutorial Sample App | "
  title = default_title + title
  return {"name" => name, "title" => title, "content" => content}
end

describe "Static pages" do
  
  pages = {"home" => page_info("Home page", "Home", "Sample App"), "help" => page_info("Help page", "Help", "Help"), "about" => page_info("About page", "About Us", "About Us")}

  pages.each do |addr, info|
   
    page_name = info["name"]
    describe page_name do 
      
      content = info["content"]
      it "should have the content #{content}" do
        visit "/static_pages/#{addr}"
        expect(page).to have_content(content)
      end
      
      title = info["title"]
      it "should have the title #{title}" do
         visit "/static_pages/#{addr}"
         expect(page).to have_title(title)
      end
    end
  end
end
