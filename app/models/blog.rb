# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  category   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  photo      :text
#  user_id    :integer
#

class Blog < ApplicationRecord
    has_many :user_blogs
    has_many :users, through: :user_blogs

    before_validation :gen_user_blogs,on: [:create]
    # before_validation :as_detail_blog_json,on: [:index]

    def gen_user_blogs(user_id = false, blog_id = false)
        UserBlog.create(user_id:user_id, blog_id:blog_id)
    end

    def as_detail_blog_json
        json = self.as_json
        json[:user_blogs] = self.user_blogs.includes(:user).map{|ub|ub.as_user_json}
        json
    end

end
