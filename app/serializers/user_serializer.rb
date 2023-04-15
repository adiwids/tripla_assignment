class UserSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :is_following do |object, params|
    params[:follower_ids].include?(object.id)
  end

  attribute :is_followed do |object, params|
    params[:followed_ids].include?(object.id)
  end
end
