FactoryGirl.define do

  factory :food do
    name "食物0"
    prot 11
    carb 12
    fat 13
    calorie((11 + 12) * 4 + 13 * 9)
  end

  factory :like do
    user
    micropost
  end

  factory :user do
    sequence(:name)  { |n| "Person_#{n}" }
    sequence(:email) { |n| "person_#{n}@163.com" }
    password "qpzmfj"
    password_confirmation "qpzmfj"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "go fuck yourself! ^_^ "
    user
  end
end
