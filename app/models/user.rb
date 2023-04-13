class User < ApplicationRecord
  validates :name, presence: true

  has_many :sleep_cycles, dependent: :destroy
  with_options(class_name: 'Following', dependent: :destroy) do
    has_many :follow_relations, foreign_key: 'follower_id'
    has_many :followed_relations, foreign_key: 'followed_id'
  end
  with_options class_name: 'User' do
    has_many :followings, through: :follow_relations, source: :followed
    has_many :followers, through: :followed_relations, source: :follower
  end
end
