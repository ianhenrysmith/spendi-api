class ApiController < ApplicationController # ActionController::API
  # include ActionController::Serialization
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  def not_found
    render json: { error: "not found" }, status: :not_found
  end

  def unauthorized
    render json: {}, status: :unauthorized
  end
end
