require 'spec_helper'

describe DailyReporter::Task do
  include FakeFS::SpecHelpers

  let(:tasks_filename) { DailyReporter::Task::TASKS_FILE }
  let(:tasks) do
    <<-TASKS
task1
task2
task3
    TASKS
  end

  before do
    prepare_home_directory
    prepare_gem_directory
    remove_file(tasks_filename)
  end

  describe 'status' do
    it 'should return empty status if file does not exist' do
      DailyReporter::Task.status.should be_nil
      File.should exist(tasks_filename)
    end

    it "should return empty status if file is empty" do
      create_empty_file(tasks_filename)
      DailyReporter::Task.status.should be_nil
    end

    it "should return file content" do
      write_to_file(tasks_filename, tasks)
      DailyReporter::Task.status.should == tasks
    end
  end

  describe "clear status" do
    it "should create empty file if file does not exist" do
      DailyReporter::Task.clear_status
      File.should exist(tasks_filename)
      file_should_have_content(tasks_filename, '')
    end

    it "should empty existing file" do
      write_to_file(tasks_filename, tasks)
      DailyReporter::Task.clear_status
      file_should_have_content(tasks_filename, '')
    end
  end

  describe "add task" do
    let(:task) { 'task' }
    it "should create a new file if file does not exist" do
      DailyReporter::Task.add(task)
      File.should exist(tasks_filename)
      file_should_have_content(tasks_filename, "#{task}\n")
    end

    it "should append new tasks to the file" do
      3.times { DailyReporter::Task.add(task) }
      status = 3.times.map{ task }.join("\n")
      file_should_have_content(tasks_filename, "#{status}\n")
    end
  end

  private

  def prepare_home_directory
    FileUtils.mkdir_p(File.expand_path('~'))
  end

  def prepare_gem_directory
    Dir.mkdir(DailyReporter::SETTINGS_DIRECTORY)
  end

  def create_empty_file(file)
    write_to_file(file)
  end

  def write_to_file(file, content = nil)
    File.open(file, 'w'){ |f| f.write content.to_s if content }
  end

  def remove_file(file)
    File.delete(file) if File.exists?(file)
  end

  def file_should_have_content(file, content)
    File.read(file).should == content
  end
end
