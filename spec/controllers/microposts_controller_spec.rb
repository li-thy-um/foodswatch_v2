require 'spec_helper'

describe MicropostsController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user, no_capybara: true }

  describe "create a micropost with food" do
    it "should respond with success" do
      xhr :post, :create, micropost: { "content" => "啊啊对方" } , foods: [{"name"=>"食物测试1", "carb"=>"10", "prot"=>"10", "fat"=>"10"}]
      expect(response).to be_success
    end
  end
end
