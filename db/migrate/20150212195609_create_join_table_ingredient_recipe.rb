class CreateJoinTableIngredientRecipe < ActiveRecord::Migration
  def change
    create_join_table :ingredients, :recipes do |t|
      t.index [:ingredient_id, :recipe_id], :unique => true
      # t.index [:recipe_id, :ingredient_id]
    end
  end
end
