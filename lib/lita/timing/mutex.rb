require 'securerandom'

module Lita
  module Timing
    class Mutex

      LOCK_TIMEOUT = 30 # seconds

      DEL_SCRIPT = <<-EOS
        if redis.call("get",KEYS[1]) == ARGV[1]
        then
          return redis.call("del",KEYS[1])
        else
            return 0
        end
      EOS

      def initialize(name, redis)
        @name, @redis = name, redis
      end

      def syncronise(&block)
        token = SecureRandom.hex(10)
        val = nil
        set_with_retry(@name, token, LOCK_TIMEOUT + 1)
        yield
        @redis.eval(DEL_SCRIPT, keys: [@name], argv: [token])
      end

      private

      def set_with_retry(name, token, timeout)
        give_up_at = Time.now + timeout
        loop do
          val = @redis.set(name, token, nx: true, ex: timeout)
          if val
            return true
          elsif Time.now > give_up_at
            raise "Unable to obtain lock for #{@name} after #{LOCK_TIMEOUT + 2} seconds"
          end
          sleep 1
        end
      end
    end
  end
end
