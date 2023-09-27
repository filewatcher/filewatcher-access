# frozen_string_literal: true

require 'filewatcher/cli/spec_helper/shell_watch_run'

require_relative 'watch_run'

class Filewatcher
  module Access
    module CLI
      module SpecHelper
        class ShellWatchRun < Filewatcher::CLI::SpecHelper::ShellWatchRun
          include Filewatcher::Access::SpecHelper::WatchRun
        end
      end
    end
  end
end
