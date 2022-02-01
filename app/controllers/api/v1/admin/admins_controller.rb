class Api::V1::Admin::AdminsController < Api::V1::Admin::AppController
before_action :set_current_admin, only: [:me,:sign_out,:update,:show_blog]

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
            render json: {success: true, jwt: admin.jwt(30.minutes.from_now)},status: :created
        else
            raise CUTAuthenticationError.new("Invalid Email or Password")    
            render json: {success:false}
        end
    end

    def me
        render json: @current_admin
    end
    
    def show_blog
        sql = "SELECT blogs.id,blogs.user_id,blogs.title,blogs.category,blogs.created_at,
        blogs.updated_at,blogs.photo,blogs.content,users.email,users.f_name,users.l_name,users.status
        FROM blogs INNER JOIN users ON (blogs.user_id = users.id)"
        @blogs = ActiveRecord::Base.connection.exec_query(sql)
        render json: @blogs
    end

    # def show_blog
    #     sql = "SELECT blogs.id,blogs.user_id,blogs.title,blogs.category,blogs.created_at,
    #     blogs.updated_at,blogs.photo,blogs.content,users.email,users.f_name,users.l_name,users.status
    #     FROM blogs INNER JOIN users ON (blogs.user_id = users.id)"
    #     @blogs = ActiveRecord::Base.connection.exec_query(sql)
    #     render json: @blogs
    # end
    
    def delete
    end

    private
    def admin_params
      params.require(:admin).permit(:id,:email,:password,:password_confirmation,:f_name,:l_name)
    end

end