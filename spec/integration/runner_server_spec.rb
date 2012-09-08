require 'spec_helper'

describe Khronos::Server::Runner do
  subject { Khronos::Server::Runner }
  let(:recurrency_check_url) { "http://localhost:8080/task?id=1" }
  let(:task_url) { 'http://test.com' }

  before(:each) do
    Khronos::Server::Runner.any_instance.stub(:new)
    Khronos::Server::Runner.any_instance.stub(:send_data)
    Khronos::Server::Runner.any_instance.stub(:close_connection)

    stub_request(:get, task_url).to_return(:body => 'it works!', :status => 200)
    stub_request(:patch, recurrency_check_url).to_return(:status => 200, :body => "", :headers => {})
  end

  it "should run a task" do
    runner = subject.new(nil)
    EM.run_block do
      runner.receive_data({:id => 1, :task_url => task_url, :recurrency => 0}.to_json)
    end
    a_request(:get, task_url).should have_been_made
    a_request(:patch, recurrency_check_url).should have_been_made
  end

end
