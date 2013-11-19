require 'spec_helper'

describe "Static pages" do
  
  it "should have the right links on the layout." do
    visit root_path
    layout_links.each do |link, page_info|
      click_link link
      expect(page).to have_title(page_info.title) 
    end
  end

  static_pages.each do |path, page_info|
      
    subject { page }
    
    describe page_info.name do

      before { eval "visit #{path}" }

      #Common Test
      it { should have_content(page_info.content) }
      it { should have_title(page_info.title) }

      #Special Case
      case page_info.name
      when "Home page"
        it { should_not have_title('| Home') }
      when "Contact page"
        it { should have_selector('h1', text: 'Contact') }
      end
    end
  end
end
