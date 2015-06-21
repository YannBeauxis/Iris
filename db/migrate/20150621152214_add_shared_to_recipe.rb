class AddSharedToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :shared, :boolean, :default => false, :null => false
    add_index  :recipes, :shared
    Recipe.reset_column_information
    Recipe.update_all(shared: false)
  end
end
