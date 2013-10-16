require 'spec_helper'

describe DailyReporter::Settings do
  include FakeFS::SpecHelpers

  describe 'method missing' do
    it "should redirect unknown method to settings" do
      DailyReporter::Settings.class_eval do
        settings.should_receive(:test_method).exactly(1).times
      end

      DailyReporter::Settings.test_method
    end

    it "should redirect private method to settings" do
      DailyReporter::Settings.class_eval do
        settings.should_receive(:settings).exactly(1).times
      end

      DailyReporter::Settings.settings
    end

    it "should not redirect public method to settings" do
      DailyReporter::Settings.class_eval do
        settings.should_receive(:init).exactly(0).times
      end
      DailyReporter::Settings.stub(:init)

      DailyReporter::Settings.init
    end
  end

  describe 'init' do
    pending "should copy settings.yml.sample and ask user to fill in correct data"
  end
end
