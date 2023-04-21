module Api
  class UsersController < BaseController
    before_action :find_target_user, only: %i[follow unfollow]

    def index
      @users = User.where.not(id: @current_user.id)
      followed_ids = @current_user.followings.map(&:id)
      follower_ids = @current_user.followers.map(&:id)

      respond_to do |format|
        format.json do
          render json: paginate(@users, UserSerializer, params: { followed_ids: followed_ids, follower_ids: follower_ids })
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

    def followings
      @followed_users = @current_user.followings

      respond_to do |format|
        format.json { render json: paginate(@followed_users, UserSerializer) }
      end
    end

    def followers
      @followers = @current_user.followers

      respond_to do |format|
        format.json do
          render json: paginate(@followers, UserSerializer, params: { followed_ids: @current_user.followings.map(&:id) })
        end
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
