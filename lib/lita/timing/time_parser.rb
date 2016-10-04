module Lita
  module Timing
    class TimeParser
      DAYS = {
        sunday: 0,
        monday: 1,
        tuesday: 2,
        wednesday: 3,
        thursday: 4,
        friday: 5,
        saturday: 6,
      }

      def self.day_string_to_int(string)
        wday = DAYS[string.to_s.downcase.to_sym]
        raise ArgumentError, "Expected one of: monday, tuesday, wednesday, thursday, friday, saturday or sunday" if wday.nil?
        wday
      end

      def self.day_strings_to_ints(strings)
        strings.map { |string| day_string_to_int(string) }
      end

      def self.extract_hours_and_minutes(string)
        _, hours, minutes = *string.match(/\A(\d{1,2}):(\d{2})\Z/)
        if hours.nil? || minutes.nil?
          raise ArgumentError, "time should be HH:MM"
        end
        if hours.to_i < 0 || hours.to_i > 23 || minutes.to_i < 0 || minutes.to_i > 59
          raise ArgumentError, "time should be HH:MM"
        end
        return hours.to_i, minutes.to_i
      end
    end
  end
end
