class AddPhotoToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :photo, :text
  end
end
