class AddDensityToIngredientTypes < ActiveRecord::Migration
  def change
    add_column :ingredient_types, :density, :float
    add_column :ingredients, :density, :float
  end
end
