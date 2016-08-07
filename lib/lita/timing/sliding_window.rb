module Lita
  module Timing
    class SlidingWindow
      def initialize(name, redis)
        @name, @redis = name, redis
        @mutex = Timing::Mutex.new("#{name}-lock", redis)

        initialise_last_time_if_not_set
      end

      def advance(duration_minutes: 30, buffer_minutes: 0, &block)
        @mutex.syncronise do
          start_time = Time.now - mins_to_seconds(duration_minutes) - mins_to_seconds(buffer_minutes)
          advance_to = start_time + mins_to_seconds(duration_minutes)

          return unless start_time > last_time

          yield last_time + 1, advance_to

          @redis.set(@name, advance_to.to_i)
        end
      end

      private

      def mins_to_seconds(mins)
        mins * 60
      end

      def last_time
        Time.at(@redis.get(@name).to_i)
      end

      def initialise_last_time_if_not_set
        @mutex.syncronise do
          @redis.setnx(@name, two_weeks_ago.to_i)
        end
      end

      def two_weeks_ago
        ::Time.now - (60 * 60 * 24 * 14)
      end

    end
  end
end
