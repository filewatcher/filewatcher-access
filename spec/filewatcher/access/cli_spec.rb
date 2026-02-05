# frozen_string_literal: true

# require 'fileutils'
require_relative 'spec_helper/shell_watch_run'

describe Filewatcher::Access::CLI do
  before do
    FileUtils.mkdir_p tmp_dir
  end

  after do
    logger.debug "FileUtils.rm_r #{tmp_dir}"
    FileUtils.rm_r tmp_dir

    Filewatcher::CLI::SpecHelper.wait seconds: 5, interval: 0.2 do
      !File.exist?(tmp_dir)
    end
  end

  def transform_spec_files(file)
    shell_watch_run_class.transform_spec_files(file)
  end

  let(:shell_watch_run_class) { described_class::SpecHelper::ShellWatchRun }
  let(:tmp_dir) { shell_watch_run_class::TMP_DIR }
  let(:tmp_files_dir) { shell_watch_run_class::TMP_FILES_DIR }
  let(:logger) { Filewatcher::SpecHelper.logger }

  let(:raw_file_name) { 'tmp_file.txt' }
  let(:initial_files) { { raw_file_name => {} } }

  let(:changes) do
    files = Array(initial_files.keys)
    files << raw_file_name if files.empty?
    files.to_h do |file|
      [transform_spec_files(file), { event: change_event, directory: change_directory }]
    end
  end

  let(:change_event) { :access }
  let(:change_directory) { false }

  let(:watch_path) { "#{tmp_files_dir}/**/*" }

  let(:dumper) { :watched }
  let(:dumper_args) { [] }
  let(:options) { { plugins: 'access' } }
  let(:watch_run) do
    shell_watch_run_class.new(
      watch_path,
      initial_files:,
      changes:,
      dumper:,
      options:,
      dumper_args:
    )
  end

  let(:dump_file_content) { File.read(shell_watch_run_class::DUMP_FILE) }
  let(:expected_dump_file_content) { 'watched' }

  shared_examples 'creating dump file' do
    describe 'file existence' do
      subject { File.exist?(shell_watch_run_class::DUMP_FILE) }

      it { is_expected.to be true }
    end

    describe 'file content' do
      subject { File.read(shell_watch_run_class::DUMP_FILE) }

      it { is_expected.to eq expected_dump_file_content }
    end
  end

  shared_examples 'not creating dump file' do
    describe 'file existence' do
      subject { File.exist?(shell_watch_run_class::DUMP_FILE) }

      it { is_expected.to be false }
    end
  end

  describe 'help output' do
    subject(:help_call) { system("#{shell_watch_run_class::EXECUTABLE} -p access --help") }

    specify do
      expect { help_call }
        .to output(/-a, --access * react to access \(read\) events/)
        .to_stdout_from_any_process
    end
  end

  describe 'ENV variables' do
    let(:filename) { 'foo.txt' }
    let(:dumper) { :env }

    let(:expected_dump_file_content) do
      [
        transform_spec_files(raw_file_name),
        raw_file_name,
        'accessed',
        transform_spec_files(nil),
        transform_spec_files(raw_file_name),
        "#{tmp_files_dir}/#{raw_file_name}",

        nil ## empty string at the end of file
      ].join("\n")
    end

    before do
      watch_run.run
    end

    ## https://github.com/filewatcher/filewatcher/issues/55#issuecomment-310889250
    if Gem.win_platform?
      it_behaves_like 'not creating dump file'
    else
      it_behaves_like 'creating dump file'
    end
  end
end
