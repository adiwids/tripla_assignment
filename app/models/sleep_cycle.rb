class SleepCycle < ApplicationRecord
  belongs_to :user

  validates :set_wake_up_time, presence: true

  enum status: %i[inactive active].freeze

  scope :latest, -> { order(created_at: :desc) }
  scope :completed, -> { inactive.where.not(actual_wake_up_time: nil) }
end
