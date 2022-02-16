# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default("0"), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  f_name                 :text
#  l_name                 :text
#  auth_token             :text
#  status                 :boolean          default("false")
#  user_profile_img       :text
#
# Indexes
#
#  index_users_on_auth_token            (auth_token) UNIQUE
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ApplicationRecord
  has_many :user_blogs
  has_many :blogs, through: :user_blogs

  def as_detail_user_json
    json = self.as_json
    json[:user_blogs] = self.user_blogs.includes(:blog).order("created_at DESC").map{|ub|ub.as_blog_json}
    json
  end
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable, :confirmable
    before_validation :generate_auth_token,on: [:create]
    
        #  ไม่ส่ง token
    def as_json(options = {})
      super(options).except("auth_token")
    end
    
    def generate_auth_token(force = false)
      # ||= เทียบค่าว่า auth_token เป็น nil หรือไม่
      #ถ้าไม่ nil ข้ามไปทำบรรทัดต่อไป
      self.auth_token ||= SecureRandom.urlsafe_base64

      # เปลี่ยน token ถ้า force เป็น true
      self.auth_token = SecureRandom.urlsafe_base64 if force
    end

    def jwt(exp = 1.days.from_now)
      payload = {exp: exp.to_i, auth_token: self.auth_token}
      JWT.encode payload, Rails.application.secret_key_base, 'HS256'
    end
    
    
end
