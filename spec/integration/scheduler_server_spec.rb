require 'spec_helper'

describe Khronos::Server::Scheduler do
  include Rack::Test::Methods

  def app
    Khronos::Server::Scheduler
  end

  it "shouldn't accept request without context" do
    get('/')
    last_response.status.should == 400
  end

  it "should accept requests with no data" do
    get('/', {:context => "invalid"})
    last_response.status.should == 200
    JSON.parse(last_response.body).should == {}
  end

  it "should schedule context to 1 week" do
    put('/', {
      :context => "invalid",
      :schedule => 1.week,
      :at => '15:00',
      :recurrency => 5
    })
    last_response.status.should == 200
  end

  xit "should enqueue schedule to run immediatelly" do
    post('/run', :id => 1)
    last_response.status.should == 200
    JSON.parse(last_response).should == {'queued' => true}
  end

end
