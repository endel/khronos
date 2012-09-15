require 'sinatra'

module Khronos
  module Server

    class Scheduler < Sinatra::Base
      set :storage, Storage.new
      before { content_type 'application/json' }

      # Greetings
      #
      get '/' do
        {
          :name => "Khronos - HTTP Job Scheduler Interface.",
          :version => Khronos::VERSION,
          :link => "https://github.com/endel/khronos"
        }
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

        if params['patch']
          # When recurrency check requested
          if schedule.recurrency > 0
            schedule.at = (Time.now + schedule.recurrency)
            schedule.active = true
          end
        else
          # When put requested
          schedule.update_attributes(params)
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

      # Schedule logs querying interface
      #
      # @param [Integer] started_at
      # @param [Integer] schedule_id
      # @param [Integer] status_code
      #
      # @return [Array] list of schedule logs
      #
      get '/schedule/logs' do
        limit = params.delete('limit')
        offset = params.delete('offset')

        relation = Storage::ScheduleLog.where(params)
        relation = relation.limit(limit) if limit
        relation = relation.offset(offset) if offset
        relation.to_json
      end

      # Create a schedule log
      #
      # @param [Integer] started_at
      # @param [Integer] status_code
      post '/schedule/log' do
        Storage::ScheduleLog.create(params).to_json
      end

    end

  end
end
