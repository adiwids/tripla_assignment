class SleepCycleSerializer
  include JSONAPI::Serializer

  attributes :set_wake_up_time,
             :actual_wake_up_time,
             :duration_seconds,
             :status,
             :created_at

  belongs_to :user, if: Proc.new { |object, params| params && params.dig(:current_user_id) != object.user_id }
end
