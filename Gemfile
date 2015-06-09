
source 'http://rubygems.org'


gem 'rails', '4.2.1'

gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.3.4'
gem 'font-awesome-rails'

gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.0'

gem 'angularjs-rails'
gem 'ng-rails-csrf'

gem 'js-routes' # use restful routes in js.

gem 'slim-rails'


group :development, :test do
  # Use sqlite instead.
  gem 'sqlite3'

  # Call 'byebug' anywhere in the code to 
  # stop execution and get a debugger console
  gem 'byebug'
  
  # Access an IRB console on exception pages or 
  # by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  
  # Spring speeds up development by keeping your 
  # application running in the background. 
  # Read more: https://github.com/rails/spring
  gem 'spring'
end


group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end


group :production do
  # Use 'pg' instead, for heroku compat.
  gem 'pg'

  # Required by Heroku.
  gem 'rails_12factor'
end


group :doc do
  gem 'sdoc', '~> 0.4.0'
end


ruby "2.2.2"