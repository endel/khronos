require 'spec_helper'

describe Khronos::Server::Scheduler do
  include Rack::Test::Methods

  def app
    Khronos::Server::Scheduler
  end

  context "tasks" do
    it "should return 404 for invalid task requests" do
      get('/task')
      last_response.status.should == 404

      get('/task', {:context => "invalid"})
      last_response.status.should == 404

      get('/task', {:id => 99})
      last_response.status.should == 404
    end

    it "should schedule context to 1 week" do
      post('/task', {
        :context => "1-week-test",
        :schedule => 1.week,
        :at => Time.now,
        :recurrency => 1.week,
        :task_url => "http://fake"
      })
      last_response.status.should == 200
      Khronos::Storage::Schedule.where(:context => "1-week-test").count.should == 1

      post('/task', {
        :context => "2-weeks-test",
        :schedule => 2.weeks,
        :at => Time.now,
        :task_url => "http://fake"
      })
      last_response.status.should == 200
      Khronos::Storage::Schedule.where(:context => "2-weeks-test").count.should == 1
    end

    it "should enqueue schedule to run immediatelly" do
      dummy_schedule = FactoryGirl.create(:schedule)
      post('/task/run', :id => dummy_schedule.id)
      last_response.status.should == 200
      JSON.parse(last_response.body).should == {'queued' => true}
    end

    it "should update schedule data" do
      dummy_schedule = FactoryGirl.create(:schedule, {
        :context => "will be updated",
        :at => Time.now,
        :active => true,
        :recurrency => 0
      })
      request('/task', :method => 'PUT', :params => {:id => dummy_schedule.id, :context => "updated"})
      schedule = Khronos::Storage::Schedule.find(dummy_schedule.id)
      schedule.active.should == true
      schedule.context.should == 'updated'
    end

    it "should update recurring time" do
      dummy_schedule = FactoryGirl.create(:schedule, {
        :at => Time.now,
        :active => false,
        :recurrency => 1.day
      })
      request('/task', :method => 'PUT', :params => {:id => dummy_schedule.id, :patch => true})
      schedule = Khronos::Storage::Schedule.find(dummy_schedule.id)
      schedule.active.should == true
      schedule.at.to_i.should == 1.day.from_now.to_i
    end

    it "should delete a scheduled task" do
      schedule = FactoryGirl.create(:schedule, {:context => "to-delete"})
      delete('/task', :id => schedule.id)
      Khronos::Storage::Schedule.where(:id => schedule.id).length.should == 0

      schedule = FactoryGirl.create(:schedule)
      delete('/task')
      last_response.status.should == 403
      last_response.body.should include("Too open")
    end

    it "should retrieve a list of schedules by context pattern" do
      FactoryGirl.create(:schedule, {:context => "namespaced"})
      FactoryGirl.create(:schedule, {:context => "namespaced:1"})
      FactoryGirl.create(:schedule, {:context => "namespaced:2"})
      FactoryGirl.create(:schedule, {:context => "namespaced:3"})
      FactoryGirl.create(:schedule, {:context => "namespaced:4"})
      FactoryGirl.create(:schedule, {:context => "namespaced:5"})

      get('/tasks', {:context => "namespaced%"})
      last_response.status.should == 200
      JSON.parse(last_response.body).length.should == 6

      get('/tasks', {:context => "namespaced"})
      last_response.status.should == 200
      JSON.parse(last_response.body).length.should == 1
    end
  end

  context "logs" do
    it "should record schedule logs" do
      data = { :schedule_id => 1, :started_at => Time.at(1347727128), :status_code => 404 }
      post('/schedule/log', data)
      last_response.status.should == 200

      schedule_log = Khronos::Storage::ScheduleLog.find(JSON.parse(last_response.body)['id'])
      schedule_log.schedule_id.should == data[:schedule_id]
      schedule_log.started_at.should == data[:started_at]
      schedule_log.status_code.should == data[:status_code]
    end

    it "should query for schedule logs" do
      FactoryGirl.create(:schedule_log, {:started_at => Time.at(1347727128), :status_code => 200, :schedule_id => 1})
      FactoryGirl.create(:schedule_log, {:started_at => Time.at(1347727128), :status_code => 500, :schedule_id => 1})
      FactoryGirl.create(:schedule_log, {:started_at => Time.at(1347727128), :status_code => 200, :schedule_id => 1})
      FactoryGirl.create(:schedule_log, {:started_at => Time.at(1347727128), :status_code => 500, :schedule_id => 2})
      FactoryGirl.create(:schedule_log, {:started_at => Time.at(1347727128), :status_code => 200, :schedule_id => 2})
      FactoryGirl.create(:schedule_log, {:started_at => Time.at(1347727128), :status_code => 404, :schedule_id => 2})
      FactoryGirl.create(:schedule_log, {:started_at => Time.at(1347727128), :status_code => 200, :schedule_id => 3})

      get('/schedule/logs', {:status_code => 200})
      last_response.status.should == 200
      JSON.parse(last_response.body).length.should == 4

      get('/schedule/logs', {:schedule_id => 2})
      last_response.status.should == 200
      logs = JSON.parse(last_response.body)
      logs.length.should == 3

      get('/schedule/logs', {:status_code => 200, :limit => 1})
      JSON.parse(last_response.body).length.should == 1

      get('/schedule/logs', {:status_code => 500, :offset => 1})
      logs = JSON.parse(last_response.body)
      logs.first['schedule_id'].should == 2
    end
  end

end
