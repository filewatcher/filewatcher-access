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

  def transform_spec_files(file)
    ruby_watch_run_class.transform_spec_files(file)
  end

  let(:ruby_watch_run_class) { Filewatcher::Access::SpecHelper::RubyWatchRun }

  let(:tmp_dir) { ruby_watch_run_class::TMP_DIR }
  let(:tmp_files_dir) { ruby_watch_run_class::TMP_FILES_DIR }
  let(:logger) { Filewatcher::Access::SpecHelper.logger }

  let(:raw_file_name) { 'tmp_file.txt' }
  let(:initial_files) { { raw_file_name => {} } }

  let(:change_event) { :access }
  let(:change_directory) { false }

  let(:changes) do
    files = Array(initial_files.keys)
    files << raw_file_name if files.empty?
    files.to_h do |file|
      [transform_spec_files(file), { event: change_event, directory: change_directory }]
    end
  end

  let(:filewatcher_files) { File.expand_path("#{tmp_files_dir}/**/*") }

  let(:filewatcher) do
    initialize_filewatcher(
      filewatcher_files, interval: 0.2, immediate: false
    )
  end

  let(:watch_run) do
    ruby_watch_run_class.new(
      initial_files: initial_files, filewatcher: filewatcher, changes: changes
    )
  end

  let(:result_transformed_filename) do
    transform_spec_files(initial_files.any? ? initial_files.keys.first : raw_file_name)
  end

  describe '#watch' do
    before do
      watch_run.run
    end

    let(:expected_result) do
      ## https://github.com/filewatcher/filewatcher/issues/55#issuecomment-310889250
      if Gem.win_platform?
        []
      else
        [{ result_transformed_filename => :accessed }]
      end
    end

    it { is_expected.to eq expected_result }
  end
end
