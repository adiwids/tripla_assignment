class SleepCycleSerializer
  include JSONAPI::Serializer

  cache_options store: Rails.cache, namespace: 'sleepcycles-jsonapi', expires_in: 8.hours

  attributes :set_wake_up_time,
             :actual_wake_up_time,
             :duration_seconds,
             :status,
             :created_at

  belongs_to :user, if: Proc.new { |object, params| params && params.dig(:current_user_id) != object.user_id }
end
