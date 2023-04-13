class SleepCycle < ApplicationRecord
  belongs_to :user

  validates :set_wake_up_time, presence: true
end
