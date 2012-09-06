module Khronos
  class Storage
    module Adapter
      @schemes = {
        'mongodb' => 'mongoid',
        'postgres' => 'activerecord',
        'mysql' => 'activerecord',
        'mysql2' => 'activerecord',
        'sqlite3' => 'activerecord'
      }
      @classes = {
        'activerecord' => 'ActiveRecord',
        'mongoid' => 'Mongoid'
      }

      def self.parse_uri(uri)
        data = URI.parse(uri)
        {
          :uri => data,
          :adapter => @schemes[data.scheme],
          :class_name => @classes[@schemes[data.scheme]]
        }
      end

      def self.get(uri)
        data = self.parse_uri(uri)

        require "khronos/storage/adapter/#{data[:adapter]}"

        # Get and connect with the adapter class.
        adapter = const_get(data[:class_name])
        adapter.connect!(data[:uri])
      end

    end
  end
end
