require 'spec_helper'

describe MicropostsController, type: :request do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user, no_capybara: true }

  describe "create a micropost with food" do
    it "should respond with success" do
      expect do
        xhr :post, :create, micropost: { "content" => "啊啊对方" }, create_type: :create, foods: [{"name"=>"食物测试1", "carb"=>"10", "prot"=>"10", "fat"=>"10"}]
      end.to change(Micropost, :count).by(1)
    end
  end

  it "with empty content should respond with success" do
    expect do
      xhr :post, :create, micropost: { "content" => "" } , create_type: :create, foods: [{"name"=>"食物测试1", "carb"=>"10", "prot"=>"10", "fat"=>"10"}]
    end.to change(Micropost, :count).by(1)
  end
end
