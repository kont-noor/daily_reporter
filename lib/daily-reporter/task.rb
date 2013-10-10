module DailyReporter
  module Task
    TASKS_FILE = DailyReporter::SETTINGS_DIRECTORY + '/tasks.txt'
    class << self
      def status
        content = File.open(TASKS_FILE, 'r+') do |f|
          f.read.strip
        end
        content.empty? ? nil : content
      end

      def clear_status
        File.open(Settings.report_file, 'w') {}
      end

      def add(task)
        File.open(Settings.report_file, 'a') do |f|
          f.puts task
        end
      end
    end
  end
end
