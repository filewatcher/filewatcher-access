# frozen_string_literal: true

require_relative 'watch_run'

class Filewatcher
  module Access
    module SpecHelper
      class RubyWatchRun < Filewatcher::SpecHelper::RubyWatchRun
        include Filewatcher::Access::SpecHelper::WatchRun
      end
    end
  end
end
