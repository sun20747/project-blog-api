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

class UserBlog < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  before_validation :destroy_user_blogs,on: [:destroy]

  def as_blog_json
    json = self.as_json
    json[:blog] = self.blog.as_json
    json
  end
  
  def as_user_json
    json = self.as_json
    json[:user] = self.user.as_json
    json
  end

  def as_user_blog_json
    json = self.all
    json
  end
  

end
