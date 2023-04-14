module Api
  class SleepCyclesController < BaseController
    def index
      @sleep_cycles = SleepCyclesLogQuery.call(owner: owner, filters: index_params)

      respond_to do |format|
        format.json do
          render json: SleepCycleSerializer.new(@sleep_cycles, is_collection: true)
        end
      end
    end

    private

    def owner
      return @current_user if params[:user_id] == @current_user.id

      params[:user_id] ? @current_user.followings.find(params[:user_id]) : @current_user
    end

    def index_params
      params.permit(:include_followings, :only_completed, :order_by)
    end
  end
end
