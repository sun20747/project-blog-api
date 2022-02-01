class Api::V1::Blog::UserBlogsController < Api::V1::Blog::AppController
  before_action :set_user_blog, only: %i[ show update destroy ]
  # before_action :set_current_user, only: [:index]

  # GET /user_blogs
  def index
    blogs = Blog.includes(:users)
    users = User.includes(:blogs)
    render json: {user: users, blog:blogs}
  end

  # GET /user_blogs/1
  def show
    render json: @user_blog
  end

  # POST /user_blogs
  def create
    @user_blog = UserBlog.new(user_blog_params)
    if @user_blog.save
      render json: @user_blog, status: :created, location: @user_blog
    else
      render json: @user_blog.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_blogs/1
  def update
    if @user_blog.update(user_blog_params)
      render json: @user_blog
    else
      render json: @user_blog.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_blogs/1
  def destroy
     @user_blog
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_blog
      @user_blog = UserBlog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_blog_params
      params.require(:user_blog).permit(:user_id, :blog_id)
    end
end
