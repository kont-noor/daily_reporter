require 'ostruct'
require 'net/imap'
require 'yaml'
require 'pry'

module Reporter
  class << self
    def report
      if email = get_mail_address
        puts email
      end
    end

    def settings
      @settings ||= get_settings
    end

    private

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
  end
end

Reporter.report
