module Api
  class UsersController < BaseController
    before_action :find_target_user, only: %i[follow unfollow]

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

    def follow
      service = FollowUserService.call(requester: @current_user, target: @target_user)
      @relation = service.object

      respond_to do |format|
        format.json do
          render json: FollowingSerializer.new(@relation), status: service.new_relation? ? :ok : :no_content
        end
      end
    end

    def unfollow
      UnfollowUserService.call(requester: @current_user, target: @target_user)

      respond_to do |format|
        format.json { head :no_content }
      end
    end

    private

    def find_target_user
      @target_user = if action_name == 'unfollow'
        @current_user.followings.find(params[:id])
      else
        User.find(params[:id])
      end
    end
  end
end
