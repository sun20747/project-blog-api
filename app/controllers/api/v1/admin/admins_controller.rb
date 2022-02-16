class Api::V1::Admin::AdminsController < Api::V1::Admin::AppController
before_action :set_current_admin, only: [:deleteblog,:confirmeduser,:resetpasswd,:deliteuserwhichblog,:deleteuserwarining,:me,:sign_out,:update,:show_blog,:show_users,:show_users_waiting,:sign_out]

    def index
        render json: {success:true}
    end

    def sign_up
    admin = Admin.new(admin_params)
    if admin.save
      render json: {success: true, admin: admin.as_json}, status: :created
    else
      render json: {success: false,errors: admin.errors.as_json},status: :bad_request
    end
    end
       
    def sign_in
        admin = Admin.find_by_email(params[:admin][:email])

        raise CUTAuthenticationError.new("Invalid Email") if admin.blank?
        # raise CUTAuthenticationError.new("Account Not verification email") if !admin.confirmed?

        if admin.valid_password?(params[:admin][:password])
            p admin.sign_in_count
          admin.sign_in_count = admin.sign_in_count + 1
          admin.save
            render json: {success: true, jwt: admin.jwt(60.minutes.from_now)},status: :created
        else
            raise CUTAuthenticationError.new("Invalid Email or Password")    
            render json: {success:false}
        end
    end

    def me
        render json: {success: true,admin: @current_admin}
    end
    
    def sign_out
    @current_admin.generate_auth_token(true)
    @current_admin.save!
    render json: {success: true}
    end

    # def show_blog
    #     sql = "SELECT blogs.id,blogs.user_id,blogs.title,blogs.category,blogs.created_at,
    #     blogs.updated_at,blogs.photo,blogs.content,users.email,users.f_name,users.l_name,users.status
    #     FROM blogs INNER JOIN users ON (blogs.user_id = users.id)"
    #     @blogs = ActiveRecord::Base.connection.exec_query(sql)
    #     render json: @blogs
    # end

  #   def show_blog
  #     sql = "SELECT blogs.id,blogs.user_id,blogs.title,blogs.category,blogs.created_at,
  #     blogs.updated_at,blogs.photo,blogs.content,users.email,users.f_name,users.l_name,users.status
  #     FROM blogs INNER JOIN users ON (blogs.user_id = users.id)"
  #     @blogs = ActiveRecord::Base.connection.exec_query(sql)
  #     render json: @blogs
  # end

    def show_users
      users = User.where("confirmed_at IS not null")
      render json: {success:true,users: users}
    end

    def show_users_waiting
      users = User.where("confirmed_at IS null").order("created_at ASC")
      render json: {success:true,users: users}
    end

    def deleteuserwarining
      User.find(params[:id]).destroy
      render json: {success: true}
    end

    def deliteuserwhichblog
      # p params[:id].to_i
      user_blogs = UserBlog.where(user_id: params[:id])
      UserBlog.where(user_id: params[:id]).delete_all if user_blogs.length > 0
      Blog.where(user_id: params[:id]).delete_all if user_blogs.length > 0
      User.find(params[:id]).destroy
      render json: {success:true}
    end

    def confirmeduser
      user = User.find(params[:id]).confirm
      render json: {success: true}
    end

    def resetpasswd
      User.find(params[:id]).reset_password(admin_params[:password],admin_params[:password])
      render json: {success: true}
    end

    def deleteblog
        UserBlog.find_by_blog_id(params[:id]).destroy
        Blog.find(params[:id]).destroy
      render json: {success:true}
    end
    

    private
    def admin_params
      params.require(:admin).permit(:id,:email,:password,:password_confirmation,:f_name,:l_name)
    end

end