require 'spec_helper'

describe "User pages" do 
  subject { page }

  user_pages.each do |path, page_info|
    describe page_info.name do
      let(:user) { page_info.user }
      before { eval "visit #{path}" }
      it { should have_content(page_info.content) }
      it { should have_title(page_info.title) }
    end
  end

  describe "signup" do 

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
 
      describe "after submission" do
        before { click_button submit }
        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "User@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end 

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success',
                                  text: 'Welcome') }
      end
    end
  end
end  
