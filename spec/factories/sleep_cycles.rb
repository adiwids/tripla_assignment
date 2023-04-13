FactoryBot.define do
  factory :sleep_cycle do
    association :user
    date { Time.zone.now.to_date }
    set_wake_up_time { Time.zone.now + 8.hours }
    actual_wake_up_time { Time.zone.now + 7.hours }
    duration_miliseconds { 0 }
  end
end
