require 'net/imap'
require 'net/smtp'

module DailyReporter
  module Mail
    class << self
      def send_status
        unless status = Task.status
          puts 'empty status'
          return
        end
        unless email = get_mail_address
          puts 'email is absent'
          return
        end

        username = Settings.mail.username
        begin
          Net::SMTP.start(Settings.mail.smtp_server, 25, Settings.mail.smtp_server, Settings.mail.username, Settings.mail.password, :plain) do |smtp|
            smtp.enable_starttls
            smtp.send_message compose_message(status, email), username, [email]
            smtp.finish
          end
          Task.clear_status
        rescue Exception => e
          puts e
        end
      end

      def get_mail_address
        imap = Net::IMAP.new(Settings.mail.imap_server, port: Settings.mail.imap_port)
        imap.authenticate('LOGIN', Settings.mail.username, Settings.mail.password)
        imap.examine('Inbox')
        id = imap.search([Settings.mail.bot_sign_container, Settings.mail.bot_sign, 'SINCE', Time.now.strftime('%-d-%b-%Y')]).last
        return nil unless id
        envelope = imap.fetch(id, 'ENVELOPE').first.attr['ENVELOPE']
        reply_to = envelope.reply_to.first
        "#{reply_to.mailbox}@#{reply_to.host}"
      end

      def compose_message(message, email)
        from = "From: <#{Settings.mail.username}>"
        to = "To: <#{email}>"
        subject = "Subject: Re: #{Settings.mail.bot_sign}"
        "#{from}\n#{to}\n#{subject}\n\n#{message}"
      end
    end
  end
end
