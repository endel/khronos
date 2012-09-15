require 'spec_helper'

describe Khronos::Server::Runner do
  subject { Khronos::Server::Runner }
  let(:recurrency_check_url) { "http://localhost:8080/task" }
  let(:schedule_log_url) { "http://localhost:8080/schedule/log" }
  let(:valid_task_url) { 'http://test.com' }
  let(:invalid_task_url) { 'http://test.com/404' }

  before(:each) do
    stub_request(:get, valid_task_url).to_return(:body => 'it works!', :status => 200)
    stub_request(:get, invalid_task_url).to_return(:status => 404)
    stub_request(:put, recurrency_check_url).with(:id => 1, :patch => true).to_return(:status => 200, :body => "", :headers => {})
  end

  it "should run a task" do
    stub_request(:post, schedule_log_url).with(:schedule_id => 1).to_return(:status => 200, :body => "", :headers => {})
    stub_request(:post, schedule_log_url).with(:schedule_id => 2, :status_code => 404).to_return(:status => 200, :body => "", :headers => {})

    runner = subject.new(nil)
    runner.process({:id => 1, :task_url => valid_task_url, :recurrency => 0}.to_json)
    runner.process({:id => 2, :task_url => invalid_task_url, :recurrency => 60}.to_json)

    a_request(:get, valid_task_url).should have_been_made
    a_request(:get, invalid_task_url).should have_been_made
    a_request(:post, schedule_log_url).with {|r| r.body =~ /schedule_id=2/ && r.body =~ /status_code=404/ }.should have_been_made
    a_request(:post, schedule_log_url).with {|r| r.body =~ /schedule_id=1/ && r.body =~ /status_code=200/ }.should have_been_made
    a_request(:put, recurrency_check_url).should have_been_made
  end

  context "callbacks" do

    xit "should trigger error callback" do
      # not implemented yet
    end

    xit "should trigger success callback" do
      # not implemented yet
    end

  end

end
