class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => false
    User.reset_column_information
    User.update_all(admin: true)
  end
end
