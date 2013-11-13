require 'spec_helper'

describe "Static pages" do
  subject {page}

  static_pages.each do |path, page_info|
    describe page_info.name do 
      before { eval "visit #{path}" }
      it { should have_content(page_info.content) }
      it { should have_title(page_info.title) }
      it { should_not have_title('| Home') } if page_info.name == "Home page"
    end
  end
end
