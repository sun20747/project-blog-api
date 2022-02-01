class AddPhotoToBlog < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :photo, :text
  end
end
