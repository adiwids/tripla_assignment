class SleepCycleSerializer
  include JSONAPI::Serializer

  attributes :set_wake_up_time,
             :actual_wake_up_time,
             :duration_miliseconds,
             :status,
             :created_at

  belongs_to :user
end
