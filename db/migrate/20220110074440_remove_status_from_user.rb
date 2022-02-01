class RemoveStatusFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :status, :boolean
  end
end
