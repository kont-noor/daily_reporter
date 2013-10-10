module DailyReporter
  module Task
    TASKS_FILE = DailyReporter::SETTINGS_DIRECTORY + '/tasks.txt'
    class << self
      def status
        content = File.open(TASKS_FILE, 'a+') do |f|
          f.read.strip
        end
        content.empty? ? nil : content
      end

      def clear_status
        File.open(TASKS_FILE, 'w') {}
      end

      def add(task)
        File.open(TASKS_FILE, 'a') do |f|
          f.puts task
        end
      end
    end
  end
end
