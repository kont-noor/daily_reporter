module DailyReporter
  SETTINGS_DIRECTORY = File.expand_path('~/.daily-reporter')
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

require 'daily-reporter/settings'
require 'daily-reporter/task'
require 'daily-reporter/mail'
