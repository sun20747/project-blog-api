class Api::V1::Blog::BlogsController < Api::V1::Blog::AppController
  before_action :set_blog, only: %i[ show update destroy]
  before_action :set_current_user, only: [:create,:update,:destroy]

  # GET /blogs
  def index
    slug = params[:category]
    limit = "ALL"
    limit = params[:limit].to_i if params[:limit].present?
    offset = params[:offset].to_i
    sql = "SELECT blogs.id,blogs.user_id,blogs.title,blogs.category,blogs.created_at,
    blogs.updated_at,blogs.photo,blogs.content,users.user_profile_img,users.email,users.f_name,users.l_name,users.status
    FROM blogs INNER JOIN users ON (blogs.user_id = users.id) order by created_at desc LIMIT #{limit} OFFSET #{offset}"

    sql_slug = "SELECT blogs.id,blogs.user_id,blogs.title,blogs.category,blogs.created_at,
    blogs.updated_at,blogs.photo,blogs.content,user_profile_img,users.email,users.f_name,users.l_name,users.status
    FROM blogs INNER JOIN users ON (blogs.user_id = users.id) WHERE category='#{slug}' order by created_at desc LIMIT #{limit} OFFSET #{offset} "

    @blogs = ActiveRecord::Base.connection.exec_query(slug == nil ? sql : sql_slug)
    
    # @blogs = Blog.all
    # @blogs = @blogs.where(category: params[:category]) if params[:category].present?
    # blog = @blogs.where(category: params[:category]) if params[:category].present?

    # @blogs = Blog.all.joins('INNER JOIN users ON (blogs.user_id = users.id)')   
    # ใช้ไม่ได้
    # User.joins(:pets).where("pets.name != 'fluffy'")
    # @blog_which_user = Blog.all(:joins => 'LEFT OUTER JOIN user ON blog.user_id = user.id')
    # @blogs = Blog.all(:joins => 'LEFT OUTER JOIN users ON (blogs.user_id = users.id)')
    # @blogs = Blog.all(:users => "JOIN users NO blogs.user_id = users.id")

    render json: @blogs
  end

  # GET /blogs/1
  def show
    render json: @blog.as_detail_blog_json
  end

  # POST /blogs
  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      @blog.gen_user_blogs(@current_user.id,@blog.id)
      @blog.user_id = @current_user.id
      @blog.save
      render json: @blog, status: :created, location: @blog
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /blogs/1
  def update
    @blog.title = blog_params[:title] if blog_params[:title].present?
    @blog.content = blog_params[:content] if blog_params[:content].present?
    @blog.category = blog_params[:category] if blog_params[:category].present?
    @blog.photo = blog_params[:photo] if blog_params[:photo].present?
    @blog.user_id = blog_params[:user_id] if blog_params[:user_id].present?
    @blog.save
    render json: {success: true},status: :created
  end

  # DELETE /blogs/1
  def destroy
    user_blog = UserBlog.find_by(blog_id: @blog.id)
    user_blog.destroy
    user_blog.save
    @blog.destroy
    render json: {success: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_blog
      @blog = Blog.find(params[:id],params[:category])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:title, :content, :category, :photo, :user_id,:limit,:offset)
    end
end
