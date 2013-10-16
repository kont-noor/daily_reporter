require 'spec_helper'
require 'stringio'

describe DailyReporter::Mail do
  describe 'send status' do
    it "should return on empty status" do
      DailyReporter::Task.stub(:status){ nil }
      capture_stdout{ DailyReporter::Mail.send_status }.should =~ /empty status/
    end

    it "should return on empty status" do
      DailyReporter::Task.stub(:status){ 'test' }
      DailyReporter::Mail.stub(:get_mail_address){ nil }
      capture_stdout{ DailyReporter::Mail.send_status }.should =~ /email is absent/
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
