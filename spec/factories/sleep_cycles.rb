FactoryBot.define do
  factory :sleep_cycle do
    association :user
    date { Time.zone.now.to_date }
    set_wake_up_time { Time.zone.now + 8.hours }
    actual_wake_up_time { nil }
    duration_miliseconds { 0 }

    inactive

    trait :active do
      status { :active }
    end

    trait :waken_up do
      status { :inactive }
      actual_wake_up_time { Time.zone.now + 7.hours }
    end

    trait :inactive do
      waken_up
    end
  end
end
