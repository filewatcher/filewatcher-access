# frozen_string_literal: true

class Filewatcher
  module Access
    module SpecHelper
      module WatchRun
        include Filewatcher::SpecHelper::WatchRun

        ACTIONS = ACTIONS.merge(
          access: -> { File.read @filename }
        )
      end
    end
  end
end
