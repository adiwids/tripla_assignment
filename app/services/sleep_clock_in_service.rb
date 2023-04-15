class SleepClockInService
  class RunningCycleError < HttpError::ForbiddenError; end

  attr_reader :user, :object

  def self.call(user:, set_wake_up_time:)
    new(user).start(set_wake_up_time)
  end

  def initialize(user)
    raise ArgumentError.new unless user.persisted?

    @user = user
  end

  def start(set_wake_up_time)
    raise RunningCycleError.new if user.sleep_cycles.active.exists?

    @object = user.sleep_cycles.create(set_wake_up_time: set_wake_up_time, date: set_wake_up_time.try(:to_date))
    object.active! if object.errors.empty?

    self
  end
end
