module Khronos
  class Storage
    module Adapter
      @frameworks = {
        'mongodb' => 'mongoid',
        'postgresql' => 'activerecord',
        'mysql2' => 'activerecord',
        'sqlite3' => 'activerecord'
      }
      @classes = {
        'activerecord' => 'ActiveRecord',
        'mongoid' => 'Mongoid'
      }
      @adapters = {
        'mongodb' => 'mongoid'
      }

      def self.parse_uri(uri)
        data = URI.parse(uri)
        {
          :scheme     => data.scheme,
          :host       => data.host,
          :user       => data.user,
          :password   => data.password,
          :path       => data.path
        }
      end

      def self.get(url)
        uri = parse_uri(url)
        framework = @frameworks[uri[:scheme]]
        require "khronos/storage/adapter/#{framework}"

        # Get and connect with the adapter class.
        const_get(@classes[framework]).connect!(url)
      end

    end
  end
end
