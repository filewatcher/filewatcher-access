# frozen_string_literal: true

require 'pry-byebug' unless RUBY_PLATFORM == 'java' || Gem.win_platform?

require 'filewatcher/cli'

require 'simplecov'

if ENV['CI']
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

SimpleCov.start

require_relative 'filewatcher/access/spec_helper'

require_relative '../lib/filewatcher/access'

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'examples.txt'
end
