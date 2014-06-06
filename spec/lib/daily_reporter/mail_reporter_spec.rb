require 'spec_helper'
require 'stringio'

describe DailyReporter::MailReporter do
  describe 'report' do
    it "should return on empty status" do
      DailyReporter::Task.stub(:status){ nil }
      capture_stdout{ DailyReporter::MailReporter.report }.should =~ /empty status/
    end

    it "should return on empty status" do
      DailyReporter::Task.stub(:status){ 'test' }
      DailyReporter::MailReporter.stub(:get_mail_address){ nil }
      capture_stdout{ DailyReporter::MailReporter.report }.should =~ /subscriber is absent/
    end
  end

  def capture_stdout &block
    old_stdout = $stdout
    fake_stdout = StringIO.new
    $stdout = fake_stdout
    block.call
    fake_stdout.string
  ensure
    $stdout = old_stdout
  end
end
