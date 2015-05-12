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

      # Common Test
      it { should have_content(page_info.content) }
      it { should have_title(page_info.title) }

      # Special Case
      case page_info.name
      when "Home page"
        it { should_not have_title('| Home') }

        # Home page test cases for signed-in users. BEGIN
        describe "for signed-in users" do
          let(:user) { user_with_microposts }
          before do
            sign_in user
            visit root_path
          end
          after { user.destroy }

          it { should have_content(user.microposts.count) }
          it { should have_selector("div.pagination") }

          it "should render the user's feed" do
            user.feed.paginate(page: 1).each do |item|
              expect(page).to have_selector("li##{item.id}", text: item.content)
            end
          end

          describe "follower/following counts" do
            let(:other_user) { FactoryGirl.create(:user) }
            before do
              other_user.follow!(user)
              visit root_path
            end

            it { should have_link("0 following",
                                   href: following_user_path(user)) }
            it { should have_link("1 followers",
                                  href: followers_user_path(user)) }

          end
        end
        # END

      when "Contact page"
        it { should have_selector('h1', text: 'Contact') }
      end
    end
  end
end
