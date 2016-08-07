module Lita
  module Timing
    class RateLimit
      def initialize(name, redis)
        @name, @redis = name, redis
        @mutex = Timing::Mutex.new("#{name}-lock", redis)
      end

      def once_every(seconds, &block)
        @mutex.syncronise do
          if last_time.nil? || last_time + seconds < Time.now
            yield
            @redis.set(@name, Time.now.to_i, ex: seconds * 2)
          end
        end
      end

      def last_time
        value = @redis.get(@name)
        value ? Time.at(value.to_i).utc : nil
      end

    end
  end
end
