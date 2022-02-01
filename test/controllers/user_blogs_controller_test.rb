require "test_helper"

class UserBlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_blog = user_blogs(:one)
  end

  test "should get index" do
    get user_blogs_url, as: :json
    assert_response :success
  end

  test "should create user_blog" do
    assert_difference("UserBlog.count") do
      post user_blogs_url, params: { user_blog: { blog_id: @user_blog.blog_id, user_id: @user_blog.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show user_blog" do
    get user_blog_url(@user_blog), as: :json
    assert_response :success
  end

  test "should update user_blog" do
    patch user_blog_url(@user_blog), params: { user_blog: { blog_id: @user_blog.blog_id, user_id: @user_blog.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy user_blog" do
    assert_difference("UserBlog.count", -1) do
      delete user_blog_url(@user_blog), as: :json
    end

    assert_response :no_content
  end
end
