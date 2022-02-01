class AddProfileToAdmin < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :f_name, :text
    add_column :admins, :l_name, :text
    add_column :admins, :auth_token, :text
    add_index :admins, :auth_token, unique: true
  end
end
