require 'spec_helper'

describe Khronos::Storage do
  subject { Khronos::Storage }

  describe Khronos::Storage::Adapter do

    it "should identify activerecord adapter for sqlite3" do
      client = subject.new('sqlite3://localhost/spec/tmp/sqlite3.db')
      Khronos::Storage::Schedule.should == Khronos::Storage::Adapter::ActiveRecord::Schedule
      Khronos::Storage::ScheduleLog.should == Khronos::Storage::Adapter::ActiveRecord::ScheduleLog
      Khronos::Storage::Schedule.create({
        :context => "test:dummy",
        :task_url => "http://some-service.com/task",
        :at => Time.now,
        :recurring => 1
      })
      Khronos::Storage::Schedule.last.task_url.should == "http://some-service.com/task"
    end

    xit "should identify mongodb adapter" do
      client = subject.new('mongodb://127.0.0.1:6379/test')
      Khronos::Storage::Schedule.should == Khronos::Storage::Adapter::Mongoid::Schedule
      Khronos::Storage::ScheduleLog.should == Khronos::Storage::Adapter::Mongoid::ScheduleLog
    end

    xit "should identify activerecord adapter for mysql" do
      client = subject.new('mysql2://localhost:3306/khronos')
      Khronos::Storage::Schedule.should == Khronos::Storage::Adapter::ActiveRecord::Schedule
      Khronos::Storage::ScheduleLog.should == Khronos::Storage::Adapter::ActiveRecord::ScheduleLog
      #Khronos::Storage::Schedule.create({:context => "dummy", :task_url => "http://www.google.com"})
    end


  end
end
