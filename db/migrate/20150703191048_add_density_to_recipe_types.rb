class AddDensityToRecipeTypes < ActiveRecord::Migration
  def change
    add_column :recipe_types, :density, :float
  end
end
