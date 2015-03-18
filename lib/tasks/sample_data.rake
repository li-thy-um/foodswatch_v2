namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_relationships
  end

  task make_posts: :environment do
    make_microposts
  end

  task delete_fake: :environment do
    users = User.where("id < 101")
    users.each do |user|
      user.destroy
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_microposts
  users = User.all.limit(6) # For the fisrt 6 users only.
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_users
  admin = User.create!(name: "Lithium",
                       email: "lithium4010@163.com",
                       password: "qpzmfj",
                       password_confirmation: "qpzmfj",
                       admin: true)
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@163.com"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end
