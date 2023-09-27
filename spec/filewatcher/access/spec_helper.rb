# frozen_string_literal: true

require 'filewatcher/spec_helper'
require 'filewatcher/cli/spec_helper'

require_relative 'spec_helper/ruby_watch_run'

class Filewatcher
  module Access
    module SpecHelper
      include Filewatcher::SpecHelper

      ## https://github.com/rubocop/ruby-style-guide/issues/556#issuecomment-828672008
      # rubocop:disable Style/ModuleFunction
      extend self
      # rubocop:enable Style/ModuleFunction
    end
  end
end
