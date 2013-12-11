FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "Person_#{n}@163.com" }
    password "qpzmfj"
    password_confirmation "qpzmfj"
  
    factory :admin do
      admin true
    end
  end
end

def random_email
  head = ('a'..'z').to_a.shuffle[0..7].join
  "#{head}@163.com"
end
