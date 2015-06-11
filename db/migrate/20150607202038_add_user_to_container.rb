class AddUserToContainer < ActiveRecord::Migration
  def change
    add_reference :containers, :user, index: true
    add_foreign_key :containers, :users
    Container.reset_column_information
    Container.update_all(user_id: 1)
  end
end
