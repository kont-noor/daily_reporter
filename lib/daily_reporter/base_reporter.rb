module DailyReporter
  class BaseReporter
    class << self
      def report
        unless status = Task.status
          puts 'empty status'
          return
        end
        unless subscriber = get_subscriber
          puts 'subscriber is absent'
          return
        end

        begin
          send_status status, subscriber
          Task.clear_status
        rescue Exception => e
          puts e
        end
      end
    end
  end
end
