FactoryGirl.define do
  factory :user do
    name "foobar"
    email "#{('a'..'z').to_a.shuffle[0..7].join}@163.com"
    password "qpzmfj"
    password_confirmation "qpzmfj"
  end
end
