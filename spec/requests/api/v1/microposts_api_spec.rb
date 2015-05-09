require 'spec_helper'

describe "Microposts API" do

  describe "DELETE destroy" do

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:micropost) { FactoryGirl.create(:micropost, user: user) }

    describe "by it's owner" do
      it 'removes a certain micropost' do
        delete "/api/v1/microposts/#{micropost.id}", auth_token: user.auth_token
        expect_success
        expect(Micropost.find_by_id micropost.id).to be_nil
      end
    end

    describe "by another user" do
      it 'renders error message' do
        delete "/api/v1/microposts/#{micropost.id}", auth_token: other_user.auth_token
        expect_fail
        expect(Micropost.find_by_id micropost.id).not_to be_nil
      end
    end
  end

  describe "POST create" do

    let(:user) { FactoryGirl.create(:user) }

    describe "micropost" do

      let(:micropost_info) do
        {content: "This is a micropost to test creation. Without foods."}
      end

      it 'creates a new micrpost' do
        post_json '/api/v1/microposts', micropost: micropost_info, auth_token: user.auth_token
        expect_success

        micropost = Micropost.find(json['data']['id'])
        expect(micropost.user_id).to eq(user.id)
        expect_same micropost_info, micropost
      end

      describe "with foods" do

        let(:food) { FactoryGirl.create(:food) }

        let(:foods_info) do
          [ {id: food.id},
            {name: "食物1", prot: 10, fat: 10, carb: 10}
          ]
        end

        it "creates a new micropost has foods" do
          post_json '/api/v1/microposts', micropost: micropost_info, foods: foods_info, auth_token: user.auth_token
          expect_success

          micropost = Micropost.find(json['data']['id'])
          expect_same micropost_info, micropost
          expect(micropost.user_id).to eq(user.id)

          foods = micropost.foods
          expect(foods.include? food).to be_true

          other_foods = foods - [food]
          expect(other_foods.size).to eq(1)

          another_food = other_foods.first
          expect_same foods_info.last, another_food
        end
      end
    end
  end
end
