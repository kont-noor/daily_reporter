require 'net/imap'
require 'net/smtp'

require 'daily_reporter/base_reporter'

module DailyReporter
  class MailReporter < BaseReporter
    class << self
      def send_status status, email
        username = Settings.mail.username
        Net::SMTP.start(Settings.mail.smtp_server, 25, Settings.mail.smtp_server, Settings.mail.username, Settings.mail.password, :plain) do |smtp|
          smtp.enable_starttls
          smtp.send_message compose_message(status, email), username, [email]
          smtp.finish
        end
      end

      def get_subscriber
        get_mail_address
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
        <<-MAIL
        From: <#{Settings.mail.username}>
        To: <#{email}>
        Subject: Re: #{Settings.mail.bot_sign}

        #{message}
        MAIL
      end
    end
  end
end
