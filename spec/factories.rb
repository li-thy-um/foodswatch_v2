FactoryGirl.define do
  
  factory :like do
    user
    micropost
  end
  
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
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
