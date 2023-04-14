class User < ApplicationRecord
  validates :name, presence: true

  has_many :sleep_cycles, dependent: :destroy
  with_options(class_name: 'Following') do
    has_many :follow_relations, foreign_key: 'follower_id', dependent: :destroy
    has_many :accepted_following_requests, -> { where(status: 'approved') }, foreign_key: 'follower_id'
    has_many :followed_relations, foreign_key: 'followed_id', dependent: :destroy
    has_many :accepted_being_followed_requests, -> { where(status: 'approved') }, foreign_key: 'followed_id'
  end
  with_options class_name: 'User' do
    has_many :followings, through: :accepted_following_requests, source: :followed
    has_many :followers, through: :accepted_being_followed_requests, source: :follower
  end
end
