module Api
  class BaseController < ActionController::Base
    include Api::ExceptionHandler

    before_action :authenticate_token!

    private

    def authenticate_token!
      @current_user = authenticate_with_http_token do |token, options|
        begin
          AuthenticateTokenService.call(token: token)
        rescue ArgumentError => _error
          # TODO: convert any exception to return HTTP 401
          nil
        end
      end
      logger.info "Accessing as #{@current_user&.name}" if Rails.env.development?

      unless @current_user
        respond_to do |format|
          format.json do
            render json: { message: 'unauthorized' }, status: :unauthorized
          end
        end
      end
    end
  end
end
