source 'https://rubygems.org'

ruby '2.0.0', patchlevel: '247'

gem 'rails'
gem 'pg'

gem 'bootstrap-sass'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'

gem 'foreman', require: false
gem 'devise'

gem 'tabnav', github: 'unboxed/tabnav', branch: 'add-ul-styling'

gem 'simple_form'
gem 'rails-i18n'

group :test do
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'poltergeist'
  gem 'shoulda-matchers'
end

group :test, :development do
  gem 'factory_girl_rails', "~> 4.0"
  gem 'rspec-rails'
  gem 'capybara'
  gem 'faker'
end

# Use debugger
gem 'pry', group: [:development, :test]
gem 'pry-debugger', group: [:development, :test]
