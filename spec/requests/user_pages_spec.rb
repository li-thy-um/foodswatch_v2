require 'spec_helper'

describe "User pages" do 
  subject { page }

  user_pages.each do |path, page_info|
    describe "signup page" do
      before { eval "visit #{path}" }
      it { should have_content(page_info.content) }
      it { should have_title(page_info.title) }
    end
  end
end

