FactoryGirl.define do
  factory :schedule, :class => Khronos::Storage::Schedule do
    sequence(:context) { |i| "context#{i}" }
    at { Time.now }
    task_url "https://github.com/endel/khronos"
    recurrency 0
  end

  factory :schedule_log, :class => Khronos::Storage::ScheduleLog do
    association :schedule
  end
end
