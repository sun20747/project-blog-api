class Api::V1::User::SessionsController < Api::V1::User::AppController
  before_action :set_current_user, only: [:me,:sign_out,:update]

  def sign_up
    user = User.new(user_params)
    if user.save
      render json: {success: true, user: user.as_json}, status: :created
    else
      render json: {success: false,errors: user.errors.as_json},status: :bad_request
    end
  end
  
  def sign_in
    user = User.find_by_email(params[:user][:email])
    p user
    raise CUTAuthenticationError.new("Invalid Email") if user.blank?
    raise CUTAuthenticationError.new("Account Not verification email") if !user.confirmed?
    
    if user.valid_password?(params[:user][:password])
      user.status = true
      user.sign_in_count = user.sign_in_count + 1
      user.save
      render json: {success: true, jwt: user.jwt(60.minutes.from_now)},status: :created
    else
      raise CUTAuthenticationError.new("Invalid Email or Password")
    end
  end

  def me
    render json: {success: true,user: @current_user.as_detail_user_json}
  end

  def sign_out
    @current_user.generate_auth_token(true)
    @current_user.status = false
    @current_user.save!
    render json: {success: true}
  end

  def update
    @current_user.f_name = user_params[:f_name] if user_params[:f_name].present?
    @current_user.l_name = user_params[:l_name] if user_params[:l_name].present?
    @current_user.save
    render json: {success: true,user: @current_user}
  end
  

  private
    def user_params
      params.require(:user).permit(:id,:email,:password,:password_confirmation,:f_name,:l_name)
    end

end
