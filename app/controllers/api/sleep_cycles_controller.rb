module Api
  class SleepCyclesController < BaseController
    def index
      @sleep_cycles = SleepCyclesLogQuery.call(owner: owner, filters: index_params)

      respond_to do |format|
        format.json do
          render json: paginate(@sleep_cycles, SleepCycleSerializer)
        end
      end
    end

    def create
      service = SleepClockInService.call(user: @current_user, set_wake_up_time: create_params[:set_wake_up_time])
      @sleep_cycle = service.object

      respond_to do |format|
        format.json do
          if @sleep_cycle.errors.empty?
            render json: SleepCycleSerializer.new(@sleep_cycle)
          else
            render json: { message: @sleep_cycle.errors.full_messages.first }, status: :unprocessable_entity
          end
        end
      end
    end

    def update
      service = WakeUpService.call(user: @current_user, actual_wake_up_time: update_params[:actual_wake_up_time])
      @sleep_cycle = service.object

      respond_to do |format|
        format.json do
          if @sleep_cycle.errors.empty?
            render json: SleepCycleSerializer.new(@sleep_cycle)
          else
            render json: { message: @sleep_cycle.errors.full_messages.first }, status: :unprocessable_entity
          end
        end
      end
    end

    private

    def owner
      return @current_user if params[:user_id] == @current_user.id

      params[:user_id] ? @current_user.followings.find(params[:user_id]) : @current_user
    end

    def index_params
      params.permit(:include_followings, :only_completed, :order_by, page: [:size, :number])
    end

    def create_params
      params.require(:sleep_cycle).permit(:set_wake_up_time)
    end

    def update_params
      params.require(:sleep_cycle).permit(:actual_wake_up_time)
    end
  end
end
