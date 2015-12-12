class AddVariantBaseToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :variant_base_id, :integer
  end
end
