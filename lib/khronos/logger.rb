module Khronos
  class Logger

    class << self
      def setup!(logger)
        @logger = logger
      end

      def method_missing(method, *args, &block)
        @logger.send(method, *args, &block)
      end

    end

  end
end
