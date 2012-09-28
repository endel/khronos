require 'uri'

module Khronos
  class Storage
    autoload :Adapter, 'khronos/storage/adapter'

    def initialize(uri=ENV['KHRONOS_STORAGE'])
      raise RuntimeError.new("Please configure 'KHRONOS_STORAGE' on your environment variables.") if uri.nil?

      @adapter = Adapter.get(uri)
      self.class.send(:include, @adapter)
    end

    def logger=(logger)
      #
      # Change logger current adapter's logger
      #
      raise NotImplementedMethod
    end

    def truncate!
      Schedule.delete_all
      ScheduleLog.delete_all
    end

  end
end
