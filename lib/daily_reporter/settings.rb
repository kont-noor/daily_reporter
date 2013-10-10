require 'ostruct'
require 'yaml'

module DailyReporter
  module Settings
    SETTINGS_FILE = DailyReporter::SETTINGS_DIRECTORY + '/settings.yml'

    class << self
      def method_missing(method)
        settings.send(method)
      end

      def init
        tmp_settings = get_settings(File.dirname(__FILE__) + '/../../config/settings.yml.sample')

        tmp_settings['mail'].each_pair do |key, value|
          puts "Input #{key.gsub('_', ' ').capitalize} (default: #{value})"
          input = STDIN.gets.chomp
          input = value if input.nil? || input.empty?
          settings.mail.send("#{key}=", input)
        end
        save_settings
      end

      private

      def settings
        @settings ||= hashes_to_ostruct(get_settings)
      end

      def get_settings(settings_file = SETTINGS_FILE)
        YAML.load_file(settings_file) || {'mail' => {}}
      rescue Errno::ENOENT
        {'mail' => {}}
      end

      def save_settings
        begin
          Dir.mkdir(SETTINGS_DIRECTORY)
        rescue Errno::EEXIST
          puts 'directory already exists'
        end

        File.open(SETTINGS_FILE, 'w') do |f|
          f.write(settings.marshal_dump.to_yaml)
        end
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
    end
  end
end
