module DailyReporter
  SETTINGS_DIRECTORY = File.expand_path('~/.daily_reporter')
  class << self
    def report
      Mail.send_status
    end

    def add_task(task)
      Task.add(task)
    end

    def tasks_list
      puts Task.status
    end

    def bootstrap
      Settings.init
    end
  end
end

require 'daily_reporter/settings'
require 'daily_reporter/task'
require 'daily_reporter/mail'
