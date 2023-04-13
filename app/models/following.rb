class Following < ApplicationRecord
  with_options class_name: 'User' do
    belongs_to :follower
    belongs_to :followed
  end

  enum status: %i[requested approved].freeze
end
