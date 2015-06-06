source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.0'

gem 'bootstrap-sass', '~> 3.3.4'

gem 'bcrypt-ruby', '3.1.2' # Use ActiveModel has_secure_password

gem 'faker', '1.1.2'

gem 'will_paginate', '3.0.6'

gem 'bootstrap-will_paginate'

gem 'sass-rails', '~>5.0.0' # Use SCSS for stylesheets

gem 'uglifier', '2.1.1' # Use Uglifier as compressor for JavaScript assets

gem 'font-awesome-sass', '~> 4.3.0'

gem 'slim'

# qiniu for avatar storage.
gem 'qiniu'

gem 'react-rails', '~> 1.0'

gem 'rest-client'

group :development do
  gem 'rspec-rails', '2.13.1'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'pry'
  gem 'pry-byebug'
end

group :development, :test do
  gem 'zeus'
end

group :development, :production do
  gem 'pg', '0.15.1'
end

group :test do
  gem 'test-unit'
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.5.0'
  gem 'database_cleaner'
end

group :production do
  gem 'rails_12factor', '0.0.2'
  gem 'rack-cache'
end

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '4.0.1'

# Use jquery as the JavaScript library
gem 'jquery-rails', '2.2.1'

# Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '0.3.20', require: false
end

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', group: :development
