require 'ostruct'
require 'net/imap'
require 'net/smtp'
require 'yaml'
require 'pry'

module Reporter
  class << self
    def report
      send_status(get_mail_address, get_status)
    end

    private

    def settings
      @settings ||= get_settings
    end

    def get_settings
      settings_hash = YAML.load_file('settings.yml')
      hashes_to_ostruct(settings_hash)
    end

    def hashes_to_ostruct(object)
      return case object
      when Hash
        object = object.clone
        object.each do |key, value|
          object[key] = hashes_to_ostruct(value)
        end
        OpenStruct.new(object)
      when Array
        object = object.clone
        object.map! { |i| hashes_to_ostruct(i) }
      else
        object
      end
    end

    def get_mail_address
      imap = Net::IMAP.new(settings.mail.imap_server, port: settings.mail.imap_port)
      imap.authenticate('LOGIN', settings.mail.username, settings.mail.password)
      imap.examine('Inbox')
      id = imap.search([settings.mail.bot_sign_container, settings.mail.bot_sign, 'SINCE', Date.today.strftime('%-d-%b-%Y')]).last
      return nil unless id
      envelope = imap.fetch(id, 'ENVELOPE').first.attr['ENVELOPE']
      reply_to = envelope.reply_to.first
      "#{reply_to.mailbox}@#{reply_to.host}"
    end

    def get_status
      content = File.read(settings.report_file).strip
      content.empty? ? nil : content
    end

    def send_status(email, status)
      if email && status
        username = settings.mail.username
        begin
          Net::SMTP.start(settings.mail.smtp_server, 25, settings.mail.smtp_server, settings.mail.username, settings.mail.password, :plain) do |smtp|
            smtp.enable_starttls
            smtp.send_message compose_message(status, email), username, [email]
            smtp.finish
          end
          clear_status
        rescue Exception => e
          puts e
        end
      end
    end

    def compose_message(message, email)
      from = "From: <#{settings.mail.username}>"
      to = "To: <#{email}>"
      subject = "Subject: Re: #{settings.mail.bot_sign}"
      date = "Date: #{DateTime.now}"
      "#{from}\n#{to}\n#{subject}\n#{date}\n\n#{message}"
    end

    def clear_status
      File.open(settings.report_file, 'w') {}
    end
  end
end

Reporter.report
