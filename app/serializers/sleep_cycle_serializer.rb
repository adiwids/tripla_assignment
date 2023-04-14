class SleepCycleSerializer
  include JSONAPI::Serializer

  attributes :set_wake_up_time, :actual_wake_up_time, :duration_miliseconds, :status

  belongs_to :user
end
