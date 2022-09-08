# frozen_string_literal: true

require 'filewatcher'

require_relative 'access/version'

## Redefine `Filewatcher::Snapshot` class
class Filewatcher
  require 'filewatcher/snapshot'

  class Snapshot
    ## Redefine `Filewatcher::Snapshot::SnapshotFile` class
    class SnapshotFile
      extend(
        Module.new do
          def populate_stats(stats)
            stats = super(stats) if defined?(super)
            stats.insert(stats.index(:mtime) + 1, :atime)
          end

          def populate_subtractions(hash)
            hash = super(hash) if defined?(super)
            hash.to_a.insert(
              hash.keys.index(:updated) + 1,
              [:accessed, ->(other) { atime && atime > other.atime }]
            )
          end
        end
      )

      attr_reader :atime
    end
  end

  ## Check for just `CLI` can fail because of CLI gemspec requirement with only `constants`
  if self::CLI.const_defined?(:Command, false)
    self::CLI::Command.option %w[-a --access], :flag, 'react to access (read) events',
      default: true
  end
end
