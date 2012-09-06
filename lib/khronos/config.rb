require 'singleton'
require 'yaml'

module Khronos
  class Config
    include Singleton
    attr_reader :settings

    def load!(file_path, env='development')
      @settings = YAML.load_file(file_path)[env]
      ENV['KHRONOS_STORAGE'] = @settings['storage']
    end

    def get(key)
      @settings[key.to_s]
    end

    def set(key, value)
      @settings[key.to_s] = value
    end

    def method_missing(name, *args, &block)
      self.get(name.to_s)
    end
  end
end
