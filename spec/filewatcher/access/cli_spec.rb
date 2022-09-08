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

  let(:filename) { 'tmp_file.txt' }
  let(:action) { :access }

  let(:shell_watch_run_class) { Filewatcher::Access::CLI::SpecHelper::ShellWatchRun }
  let(:tmp_dir) { shell_watch_run_class::TMP_DIR }
  let(:logger) { Filewatcher::SpecHelper.logger }

  let(:dumper) { :watched }
  let(:dumper_args) { [] }
  let(:options) { { plugins: 'access' } }
  let(:watch_run) do
    shell_watch_run_class.new(
      filename: filename,
      action: action,
      dumper: dumper,
      options: options,
      dumper_args: dumper_args
    )
  end

  ## https://github.com/filewatcher/filewatcher/issues/55#issuecomment-310889250
  let(:expected_dump_file_existence) { !Gem.win_platform? }

  let(:dump_file_content) { File.read(shell_watch_run_class::DUMP_FILE) }
  let(:expected_dump_file_content) { 'watched' }

  shared_examples 'dump file existence' do
    describe 'file existence' do
      subject { File.exist?(shell_watch_run_class::DUMP_FILE) }

      it { is_expected.to be expected_dump_file_existence }
    end
  end

  shared_examples 'dump file content' do
    ## https://github.com/filewatcher/filewatcher/issues/55#issuecomment-310889250
    unless Gem.win_platform?
      describe 'file content' do
        subject { dump_file_content }

        it { is_expected.to eq expected_dump_file_content }
      end
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
      %W[
        #{tmp_dir}/#{filename}
        #{filename}
        accessed
        #{tmp_dir}
        #{tmp_dir}/#{filename}
        spec/tmp/#{filename}
      ].join(', ')
    end

    before do
      watch_run.run
    end

    include_examples 'dump file existence'

    include_examples 'dump file content'
  end
end
