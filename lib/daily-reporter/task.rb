module DailyReporter
  module Task
    class << self
      def status
        content = File.read(Settings.report_file).strip
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
