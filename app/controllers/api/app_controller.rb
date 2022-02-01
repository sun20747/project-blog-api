class Api::AppController < ApplicationController
  # before_action :set_locale
  rescue_from JWT::DecodeError, with: :jwt_failed
  rescue_from JWT::ExpiredSignature, with: :jwt_failed
  rescue_from JWT::ImmatureSignature, with: :jwt_failed
  rescue_from JWT::InvalidIssuerError, with: :jwt_failed
  rescue_from JWT::InvalidIatError, with: :jwt_failed
  rescue_from JWT::VerificationError, with: :jwt_failed
  # rescue_from CUTError, with: :handle_cut_error
  rescue_from CUTAuthenticationError, with: :handle_cut_authentication_error
  # rescue_from GKUserNotFoundError, with: :handle_gk_authentication_error
  # rescue_from GKNotAuthorizedError, with: :handle_gk_authentication_error
  # rescue_from ActionController::ParameterMissing, with: :handle_other_error
  # rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found_error
  # rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid_error


  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  # end
  

  def jwt_failed(err)
    render json: { success: false, error: err.to_s }, status: :unauthorized and return
  end

  # def handle_cut_error(err)
  #   render json: { success: false, error: err.message }, status: :bad_request and return
  # end

  def handle_cut_authentication_error(err)
    render json: { success: false, error: err.message }, status: :unauthorized and return
  end

  # def handle_not_found_error(err)
  #   render json: { success: false, error: err.message }, status: :not_found and return
  # end

  # def handle_other_error(err)
  #   render json: { success: false, error: err.message }, status: :bad_request and return
  # end

  # def handle_record_invalid_error(err)
  #   render json: { success: false, error: err.message, details: err.record.errors.as_json }, status: :bad_request and return
  # end

  # def handle_invalid_transition_error(err)
  #   render json: { success: false, error: err.message }, status: :bad_request and return
  # end
end
