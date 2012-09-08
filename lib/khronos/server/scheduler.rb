require 'sinatra'

module Khronos
  module Server

    class Scheduler < Sinatra::Base
      set :storage, Storage.new

      # Retrieves scheduling data from a context
      #
      # @return [Hash] JSON
      get '/' do
        # context = retrieve_context!
        {}.to_json
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

      post '/run' do
        schedule = Storage::Schedule.where(:id => params[:id]).first
        {:queued => !schedule.nil?}.to_json
      end

      private

        def retrieve_context!
          halt 400, "Missing 'context' on query string." unless params[:context]
          (params[:namespace].nil?) ? params[:context] : "#{params[:namespace]}:#{params[:context]}"
        end

    end

  end
end
