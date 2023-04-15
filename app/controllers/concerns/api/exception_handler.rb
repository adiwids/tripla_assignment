module Api::ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found_error
  end

  protected

  # TODO: convert exception message to be more comprehensive
  def handle_not_found_error(error)
    respond_to do |format|
      format.json { render json: { message: 'Resource not found' }, status: :not_found }
    end
  end
end
