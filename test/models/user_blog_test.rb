# == Schema Information
#
# Table name: user_blogs
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  blog_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_blogs_on_blog_id  (blog_id)
#  index_user_blogs_on_user_id  (user_id)
#

require "test_helper"

class UserBlogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
