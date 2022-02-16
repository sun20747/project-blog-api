class AddProfilephotoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_profile_img, :text
  end
end
