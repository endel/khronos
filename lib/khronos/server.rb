require 'sinatra'

module Khronos
  class Server < Sinatra::Base
    set :storage, Storage.new

    # Retrieves scheduling data from a context
    #
    # @return [Hash] JSON
    get '/' do
      context = retrieve_context!
      {}.to_json
      #settings.storage.get(context).to_json
    end

    # Creates or updates a schedule from a context
    #
    # @param [String]
    #
    # @return [Hash] Context JSON status hash
    put '/' do
      context = retrieve_context!
      puts params.inspect
      context.to_json
    end

    private

      def retrieve_context!
        halt 400, "Missing 'context' on query string." unless params[:context]
        (params[:namespace].nil?) ? params[:context] : "#{params[:namespace]}:#{params[:context]}"
      end

  end
end
