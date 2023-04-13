class WakeUpService
  attr_reader :user, :object

  def self.call(user:, actual_wake_up_time:)
    new(user).stop(actual_wake_up_time)
  end

  def initialize(user)
    raise ArgumentError.new unless user.persisted?

    @user = user
    @object = user.sleep_cycles.active.latest.first
  end

  def stop(actual_wake_up_time)
    raise StandardError.new unless object
    raise ArgumentError.new unless actual_wake_up_time

    if valid_wake_up_time?(actual_wake_up_time)
      attributes = {
        actual_wake_up_time: actual_wake_up_time,
        duration_miliseconds: calculate_duration(actual_wake_up_time)
      }
      object.inactive! if object.update(attributes)
    end

    self
  end

  private

  def valid_wake_up_time?(actual_wake_up_time)
    return false unless actual_wake_up_time

    if (actual_wake_up_time.to_date - object.date).negative?
      object.errors.add(:actual_wake_up_time, :must_be_equal_to_or_greater_than_date)
      return false
    end

    return true
  end

  def calculate_duration(actual_wake_up_time)
    (actual_wake_up_time - object.created_at).to_i
  end
end
