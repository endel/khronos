require 'spec_helper'

describe Khronos::Server::Scheduler do
  include Rack::Test::Methods

  def app
    Khronos::Server::Scheduler
  end

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
  end

  it "should enqueue schedule to run immediatelly" do
    mock_tcp_next_request("")
    dummy_schedule = FactoryGirl.create(:schedule)
    post('/task/run', :id => dummy_schedule.id)
    last_response.status.should == 200
    JSON.parse(last_response.body).should == {'queued' => true}
  end

  it "should update recurring time" do
    dummy_schedule = FactoryGirl.create(:schedule, {
      :at => Time.now,
      :active => false,
      :recurrency => 1.day
    })
    request('/task', :method => 'PATCH', :params => {:id => dummy_schedule.id})
    schedule = Khronos::Storage::Schedule.find(dummy_schedule.id)
    schedule.active.should == true
    schedule.at.to_i.should == 1.day.from_now.to_i
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
