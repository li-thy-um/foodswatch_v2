require 'spec_helper'

describe "MicropostPages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost destruction" do
    let(:followed)      { FactoryGirl.create(:user) }
    let!(:self_post)     { FactoryGirl.create(:micropost, user: user) }
    let!(:followed_post) { FactoryGirl.create(:micropost, user: followed) }
   
    # TODO implement user.follow
    # before { user.follow followed }

    describe "as correct user" do
      before { visit root_path }

      it "should not have a delete link attach to a followed micropost" do
        # TODO Temp case before implement the 'follow' function.
        if page.has_css?("##{followed_post.id}")
          expect(find_by_id followed_post.id).not_to have_link('delete') 
        end
      end

      it "should be able to delete a self-post micropost" do 
        expect { (find_by_id self_post.id).click_link "delete" }.
          to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "micropost creation" do 
    before { visit root_path }
    
    describe "with invalid information" do 
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error message" do 
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do 
      
      before { fill_in 'micropost_content', with: "Go fuck yourself ^_^" }
      it "should create a micropost" do 
        expect { click_button "Post".to change(Micropost, :count).by(1) }
      end
    end
  end
end
