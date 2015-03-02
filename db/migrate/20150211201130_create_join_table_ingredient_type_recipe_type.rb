class CreateJoinTableIngredientTypeRecipeType < ActiveRecord::Migration
  def change
    create_join_table :ingredient_types, :recipe_types do |t|
      # t.index [:ingredient_type_id, :recipe_type_id]
      # t.index [:recipe_type_id, :ingredient_type_id]
    end
  end
end
