source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1'

# Allow any model to follow any other model
gem "acts_as_follower", github: "gaganlokesh/acts_as_follower", branch: "main"
# Simple, Fast, and Declarative Serialization Library for Ruby
gem 'blueprinter', '~> 0.25.3'
# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.8'
# OAuth 2 provider for Ruby on Rails
gem 'doorkeeper', '~> 5.5'
# Assertion grant extension for Doorkeeper
gem 'doorkeeper-grants_assertion', '~> 0.3'
# Simple, but flexible HTTP client library, with support for multiple backends.
gem 'faraday', '~> 1.5'
# Slugging and permalink plugin for Active Record
gem 'friendly_id', '~> 5.4.0'
# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for Ruby webapps
gem 'kaminari-activerecord', "~> 1.2"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # A library for generating fake data such as names, addresses, and phone numbers.
  gem "faker", "~> 2.18"
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Ruby static code analyzer and formatter
  gem 'rubocop', '~> 1.13', require: false
  # Rubocop extension for rails
  gem 'rubocop-rails', '~> 2.9', require: false
  # Rubocop extension focused on code performance checks
  gem 'rubocop-performance', '~> 1.11', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
