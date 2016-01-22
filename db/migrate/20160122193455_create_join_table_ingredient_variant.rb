class CreateJoinTableIngredientVariant < ActiveRecord::Migration
  def change
    create_join_table :ingredients, :variants do |t|
      t.index [:ingredient_id, :variant_id], :unique => true
    end
    Variant.find_each do |v|
      v.ingredients = v.recipe.ingredients
      v.save
    end
  end
end
