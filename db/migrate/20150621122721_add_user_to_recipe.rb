class AddUserToRecipe < ActiveRecord::Migration
  def change
    add_reference :recipes, :user, index: true
    add_foreign_key :recipes, :users
    Recipe.reset_column_information
    Recipe.update_all(user_id: 1)
  end
end
