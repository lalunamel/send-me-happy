source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'mysql2'
gem 'puma'
gem 'capistrano', group: :development
gem 'phony_rails' # phone validation
gem 'twilio-ruby' # twillio rails gem
gem 'bcrypt-ruby'
gem 'json'
gem "active_model_serializers" # for formatting json responses
gem 'jsend-rails' # for rendering jsend responses
gem 'indefinite_article' # for prepending a or an to a word without or with a vowel
gem 'high_voltage' # for static pages
gem 'stalker' # for beanstalkd job queuing

# gem 'jquery-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'quiet_assets'
  gem 'rspec-rails', '~> 2.0'
  gem 'byebug'
  gem 'jasmine'
  gem "therubyracer", :require => 'v8'
  gem 'factory_girl_rails', :require => false
	gem 'forgery' # random data generation
end
