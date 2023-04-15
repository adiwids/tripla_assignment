module Api::ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found_error
    rescue_from HttpError::ForbiddenError, with: :handle_forbidden_error
    rescue_from ActionController::ParameterMissing, HttpError::BadRequestError, with: :handle_bad_request_error
  end

  protected

  # TODO: convert exception message to be more comprehensive
  def handle_not_found_error(error)
    render_json_error error, :not_found
  end

  def handle_forbidden_error(error)
    render_json_error error, :forbidden
  end

  def handle_bad_request_error(error)
    render_json_error error, :bad_request
  end

  private

  def render_json_error(error, http_status)
    respond_to do |format|
      format.json { render json: { message: error.message }, status: http_status }
    end
  end
end
