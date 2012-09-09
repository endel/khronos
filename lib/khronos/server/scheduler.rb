require 'sinatra'

module Khronos
  module Server

    class Scheduler < Sinatra::Base
      set :storage, Storage.new

      # Introduction
      get '/' do
        <<-EOF
        <html>
          <head>
            <title>Khronos #{Khronos::VERSION}</title>
          </head>
          <body>
            <h1>HTTP Job Scheduler Interface.</h1>
            <p>
              <a href="http://rubygems.org/gems/khronos">Khronos #{Khronos::VERSION}</a><br />
              by <a href="https://github.com/endel">Endel Dreyer</a>
            </p>
          </body>
        </html>
        EOF
      end

      # Creates a schedule
      #
      # @param [String]       context     application-level identifier
      # @param [Integer]      at          timestamp which will run for the first time
      # @param [Integer]      recurrency  next execution interval, in seconds
      # @param [String]       task_url    url of the task that will run
      # @param [String, JSON] callbacks   callback urls (e.g. '{"success" : ... , "error" : ...}')
      #
      # @return [Hash] created schedule data
      post '/task' do
        Storage::Schedule.create(params).to_json
      end

      # Retrieves scheduling tasks from a context
      #
      # @param [Integer] id
      # @param [String] context
      #
      # @return [Hash] JSON
      get '/task' do
        schedule = (!params.empty?) ? Storage::Schedule.where(params).first : nil
        if schedule.nil?
          # Requested task not found
          404
        else
          schedule.to_json
        end
      end

      # Retrieve a list of scheduling tasks
      get '/tasks' do
        if Storage::Schedule.name =~ /ActiveRecord/
          criteria = Storage::Schedule
          params.each_pair do |field, value|
            if field == 'context'
              field = "#{field} LIKE ?"
            else
              field = "#{field} = ?"
            end
            criteria = criteria.where(field, value)
          end
          criteria.to_json
        else
          Storage::Schedule.where(params).to_json
        end
      end

      # Creates or updates a schedule from a context
      #
      # @param [String]
      #
      # @return [Hash] Context JSON status hash
      put '/task' do
        schedule = Storage::Schedule.where({:id => params.delete('id')}).first

        # No schedule found for this params.
        return {}.to_json unless schedule

        schedule.update_attributes(params)
        schedule.save

        schedule.to_json
      end

      # Checks recurrency and reactivates a schedule if necessary
      #
      # @param [String] id
      #
      # @return [Hash] data
      patch '/task' do
        schedule = Storage::Schedule.where(params).first

        # No schedule found for this params.
        return {}.to_json unless schedule

        # Is recurrency check requested
        if schedule.recurrency > 0
          schedule.at += schedule.recurrency
          schedule.active = true
        end
        schedule.save

        schedule.to_json
      end

      # Force a task to be scheduled right now
      #
      # @param [Integer] id
      #
      # @return [Hash] queued
      post '/task/run' do
        schedule = Storage::Schedule.where(:id => params[:id]).first
        Khronos::Scheduler.run(schedule) if schedule
        {:queued => !schedule.nil?}.to_json
      end

      # Log requests

    end

  end
end
