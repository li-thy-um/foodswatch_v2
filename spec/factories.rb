FactoryGirl.define do
  factory :user do
    name "foobar"
    sequence(:email) { |n| random_email }
    password "qpzmfj"
    password_confirmation "qpzmfj"
  end
end

def random_email
  head = ('a'..'z').to_a.shuffle[0..7].join
  "#{head}@163.com"
end
