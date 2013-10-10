require 'daily-reporter/settings'
require 'daily-reporter/task'
require 'daily-reporter/mail'

module DailyReporter
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
  end
end
