class FollowingSerializer
  include JSONAPI::Serializer

  attributes :status, :created_at, :updated_at

  belongs_to :follower, serializer: :user
  belongs_to :followed, serializer: :user
end
