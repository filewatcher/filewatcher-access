# frozen_string_literal: true

RSpec.describe Filewatcher::Access do
  subject(:processed) { watch_run.processed }

  before do
    FileUtils.mkdir_p tmp_dir
  end

  after do
    logger.debug "FileUtils.rm_r #{tmp_dir}"
    FileUtils.rm_r tmp_dir

    Filewatcher::Access::SpecHelper.wait seconds: 5, interval: 0.2 do
      !File.exist?(tmp_dir)
    end
  end

  def initialize_filewatcher(path, options = {})
    Filewatcher.new(path, options.merge(logger: logger))
  end

  let(:tmp_dir) { Filewatcher::Access::SpecHelper::WatchRun::TMP_DIR }
  let(:logger) { Filewatcher::Access::SpecHelper.logger }

  let(:filename) { 'tmp_file.txt' }
  let(:action) { :access }

  let(:filewatcher) do
    initialize_filewatcher(
      File.join(tmp_dir, '**', '*'), interval: 0.2, immediate: false
    )
  end

  let(:watch_run) do
    Filewatcher::Access::SpecHelper::RubyWatchRun.new(
      filename: filename, filewatcher: filewatcher, action: action
    )
  end

  let(:processed_files) { watch_run.processed.flat_map(&:keys) }

  describe '#watch' do
    before do
      watch_run.run
    end

    it { is_expected.to eq [{ watch_run.filename => :accessed }] }
  end
end
