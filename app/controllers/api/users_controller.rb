module Api
  class UsersController < BaseController
    def index
      @users = User.where.not(id: @current_user.id)
      followed_ids = @current_user.followings.map(&:id)
      follower_ids = @current_user.followers.map(&:id)
      options = {
        is_collection: true,
        params: { followed_ids: followed_ids, follower_ids: follower_ids }
      }.freeze

      respond_to do |format|
        format.json do
          render json: UserSerializer.new(@users, options)
        end
      end
    end
  end
end
