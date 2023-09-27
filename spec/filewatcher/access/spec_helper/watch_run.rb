# frozen_string_literal: true

class Filewatcher
  module Access
    module SpecHelper
      module WatchRun
        include Filewatcher::SpecHelper::WatchRun

        CHANGES = CHANGES.merge(
          access: ->(change_file, *_args) { File.read change_file }
        )
      end
    end
  end
end
