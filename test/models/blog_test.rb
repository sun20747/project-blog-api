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

require "test_helper"

class BlogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
