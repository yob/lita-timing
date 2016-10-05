require 'lita/timing/time_parser'
require 'lita/timing/mutex'

module Lita
  module Timing
    class Scheduled
      ONE_WEEK_IN_SECONDS = 60 * 60 * 24 * 7

      def initialize(name, redis)
        @name, @redis = name, redis
        @mutex = Timing::Mutex.new("#{name}-lock", redis)
      end

      def daily_at(time, days = nil, &block)
        @mutex.syncronise do
          days ||= [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
          last_run_at = get_last_run_at
          next_run = calc_next_daily_run(time, days, last_run_at)
          if next_run < Time.now
            yield
            set_last_run_at
          end
        end
      end

      def weekly_at(time, day, &block)
        @mutex.syncronise do
          last_run_at = get_last_run_at
          next_run = calc_next_weekly_run(time, day, last_run_at)
          if next_run < Time.now
            yield
            set_last_run_at
          end
        end
      end

      private

      def calc_next_daily_run(time, days, last_run_at)
        hours, minutes = TimeParser.extract_hours_and_minutes(time)
        wdays = TimeParser.day_strings_to_ints(days)

        next_run_at = last_run_at + 1
        loop do
          if next_run_at.hour == hours && next_run_at.min == minutes && next_run_at.sec == 0 && wdays.include?(next_run_at.wday)
            return next_run_at
          end
          next_run_at += 1
        end
      end

      def calc_next_weekly_run(time, day, last_run_at)
        hours, minutes = TimeParser.extract_hours_and_minutes(time)
        wday = TimeParser.day_string_to_int(day)

        next_run_at = last_run_at + 1
        loop do
          if next_run_at.hour == hours && next_run_at.min == minutes && next_run_at.sec == 0 && next_run_at.wday == wday
            return next_run_at
          end
          next_run_at += 1
        end
      end

      def get_last_run_at
        value = @redis.get(@name)
        value ? Time.at(value.to_i).utc : set_last_run_at
      end

      def set_last_run_at(time = Time.now.utc)
        @redis.set(@name, time.to_i, ex: ONE_WEEK_IN_SECONDS * 2)
        time
      end
    end
  end
end
