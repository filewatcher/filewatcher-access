# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
  gem 'filewatcher-cli', '~> 1.1'

  # gem 'filewatcher', path: '../filewatcher', require: false
  # gem 'filewatcher-cli', path: '../filewatcher-cli', require: false

  gem 'pry-byebug', '~> 3.9' unless RUBY_PLATFORM == 'java' || Gem.win_platform?
end

group :development, :audit do
  gem 'bundler-audit', '~> 0.9.0'
end

group :development, :toys do
  gem 'gem_toys', '~> 0.13.0'
  gem 'toys', '~> 0.15.3'
end

group :development, :test do
  gem 'rspec', '~> 3.9'
  gem 'simplecov', '~> 0.22.0'
  gem 'simplecov-cobertura', '~> 2.1'
end

group :development, :lint do
  gem 'rubocop', '~> 1.59.0'
  gem 'rubocop-performance', '~> 1.0'
  gem 'rubocop-rspec', '~> 2.0'
end
