class UserSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :is_following, if: Proc.new { |object, params| params && params.key?(:follower_ids) } do |object, params|
    params[:follower_ids].include?(object.id)
  end

  attribute :is_followed, if: Proc.new { |object, params| params && params.key?(:followed_ids) } do |object, params|
    params[:followed_ids].include?(object.id)
  end
end
