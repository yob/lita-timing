module Lita
  module Timing
    class RateLimit
      def initialize(name, redis)
        @name, @redis = name, redis
      end

      def once_every(seconds, &block)
        if last_time.nil? || last_time + seconds < Time.now
          yield
          @redis.set(@name, Time.now.to_i)
        end
      end

      def last_time
        value = @redis.get(@name)
        value ? Time.at(value.to_i).utc : nil
      end

    end
  end
end
