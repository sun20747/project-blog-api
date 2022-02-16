class AddProfilephotoToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :admin_profile_img, :text
  end
end
