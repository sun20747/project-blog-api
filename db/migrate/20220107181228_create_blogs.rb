class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.text :title
      t.text :content
      t.text :category

      t.timestamps
    end
  end
end
