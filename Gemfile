source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.3.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
gem 'rails-i18n', '~> 5.1'

# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'jwt', '~> 2.1'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# config
gem 'figaro', '~> 1.1'

# grape
gem 'grape', '~> 1.2'
gem 'hashie', '~> 3.6'
gem 'grape-entity', '~> 0.7'

# swagger
gem 'grape-swagger', '~> 0.32' # grape doc
gem 'grape-swagger-entity', '~> 0.3'

# taggable
gem 'acts-as-taggable-on', '~> 6.0'
gem 'acts_as_commentable_with_threading', '~> 2.0.1'

# paginate
gem 'kaminari', '~> 0.17'

# background job
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'sidekiq', '~> 5.2'

# admin role
gem 'rolify', '~> 5.2'
gem "pundit"

# GraphQL
gem 'graphql', '~> 1.9'
gem 'graphiql-rails', '~> 1.7.0', group: :development

# like, favorite
gem 'action-store', '~> 0.4'

# http client
gem 'rest-client', '~> 2.0'

# file uploader
gem 'carrierwave', '~> 2.0'
gem 'carrierwave-i18n'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'rubocop', require: false
  gem 'rubocop-performance'

  gem 'rspec-rails', '~> 3.8'
end

group :development do
  # gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # swagger
  gem 'grape-swagger-rails', '~> 0.3' # a web page

  # format print
  gem 'awesome_print'

  # capistrano deploy
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-rails', '~> 1.3', require: false
  gem 'capistrano3-puma', '~> 3.1.1'
  gem 'capistrano-rvm', '~> 0.1.2', require: false
  gem 'capistrano-sidekiq', '~> 1.0.2', github: 'seuros/capistrano-sidekiq'
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
