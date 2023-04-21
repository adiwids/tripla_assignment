class FollowingSerializer
  include JSONAPI::Serializer

  attributes :status, :created_at, :updated_at

  belongs_to :follower, serializer: :user, if: Proc.new { |object, params| params && params.dig(:current_user_id) != object.follower_id }
  belongs_to :followed, serializer: :user, if: Proc.new { |object, params| params && params.dig(:current_user_id) != object.followed_id }
end
