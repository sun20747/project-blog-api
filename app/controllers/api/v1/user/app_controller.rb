class Api::V1::User::AppController < Api::AppController
  
  def set_current_user
    auth_header = request.headers["auth-token"]
    raise CUTAuthenticationError.new("Not token") if auth_header.blank?
    bearer = auth_header.split.first
    raise CUTAuthenticationError.new("Bad format") if bearer != "Bearer"
    jwt = auth_header.split.last
    raise CUTAuthenticationError.new("Bad format") if jwt.blank?
    decoded = JWT.decode(jwt,Rails.application.secret_key_base,'HS256')
    payload = decoded.first
    if payload.blank? || payload["auth_token"].blank?
      raise CUTAuthenticationError.new("Bad token")
    end
    @current_user = User.find_by_auth_token(payload["auth_token"])
    
    raise CUTAuthenticationError.new("Bad token") if @current_user.blank?
  end
  
  # def set_current_user
  #   auth_header = request.headers["auth-token"]
  #   raise CUTAuthenticationError.new("Not logged in") if auth_header.blank?
  #   auth_split = auth_header.split(" ")
  #   raise CUTAuthenticationError.new("Not logged in") if auth_split.first != "Bearer"
  #   auth_jwt = auth_split.last
  #   payload = ApiJwt.decrypt_jwt(auth_jwt, Rails.application.credentials.user_jwt_secret) rescue nil
  #   raise CUTAuthenticationError.new("Not logged in") if payload.blank? || payload["auth_token"].blank?
  #   @current_user = User.find_by_auth_token(payload["auth_token"])
  # end

  # before_action :set_current_user

  # def current_user(check = true)
  #   raise CUTAuthenticationError.new("Not logged in") if check && @current_user.blank?
  #   @current_user
  # end

  
  
end
