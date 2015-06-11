class AddApprovedToUser < ActiveRecord::Migration
  def change
    add_column :users, :approved, :boolean, :default => false, :null => false
    add_index  :users, :approved
    User.reset_column_information
    User.update_all(approved: true)
  end
end
