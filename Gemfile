source 'https://rubygems.org'

ruby '2.0.0', patchlevel: '247'

gem 'rails'
gem 'pg'

gem 'bootstrap-sass'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'foreman', require: false
gem 'devise'

gem 'launchy'

gem 'tabnav', github: 'unboxed/tabnav', branch: 'add-ul-styling'

gem 'simple_form', '~> 3.1.0.rc1'
gem 'simplecov'
gem 'rails-i18n'

gem 'dotenv-rails'

group :test do
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem "codeclimate-test-reporter", require: false
end

group :test, :development do
  gem 'factory_girl_rails', "~> 4.0"
  gem 'rspec-rails'
  gem 'capybara'
  gem 'faker'
  gem 'pry'
  gem 'pry-debugger'
  gem 'timecop'
end

group :production do
  gem 'rails_12factor'
end
