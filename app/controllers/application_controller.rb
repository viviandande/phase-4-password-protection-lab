class ApplicationController < ActionController::API
  include ActionController::Cookies
  wrap_parameters format: []
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_response
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response

  before_action :authorize

  private

  def record_invalid_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

  def record_not_found_response
    render json: { error: "#{controller_name.classify} not found" },status: :not_found
  end

  def authorize
    return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end
end