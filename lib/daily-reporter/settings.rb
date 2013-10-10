require 'ostruct'
require 'yaml'

module DailyReporter
  module Settings
    class << self
      def method_missing(method)
        settings.send(method)
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
    end
  end
end
