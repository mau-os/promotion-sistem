class Api::V1::ApiController < ActionController::API
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  rescue_from ActiveRecord::RecordNotSaved, with: :not_saved_error
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_error

  private

    def not_found_error
      head 404
    end
    
    def not_saved_error(exception)
      render json: { errors: exception }, status: :not_acceptable
    end
    
    def invalid_error(exception)
      render json: { errors: exception }, status: :unprocessable_entity
    end
end