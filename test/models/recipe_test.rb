require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  test "Create Recipe" do
    u = users(:one)
    r = u.recipes.create! do |ur|
      ur.name = 'Recipe test'
      ur.type = recipe_types(:one)
   end
   assert_includes u.recipes, r,
    'Recipe not created'
    assert_not r.variant_base_id.nil?, 'variant base not created'
   assert_not r.shared?,
    'Shared is not false'
   r.shared = true
   r.save
   assert r.shared?
  end
  
  test "no_delete_variant_base_id" do
    u = users(:one)
    r = u.recipes.create! do |ur|
      ur.name = 'Recipe test'
      ur.type = recipe_types(:one)
   end
   v_id = r.variant_base_id
    r.variant_base_id = nil
    r.save
    assert r.variant_base_id == v_id, 'variant_base_id can\'t be nil'
  end

  test "ingredients_types" do
    r=recipes(:one)
    r.variant_base_id = variants(:one).id
    r.save
    it = ingredient_types(:one)
    assert_includes r.ingredient_types, it
  end
  
  test "ingredients_all_variants" do
    r=recipes(:recipe_ingredients_all_variants)
    v_one = variants(:recipe_ingredients_all_variants_one)
    v_one.update_proportions
    v_three = variants(:recipe_ingredients_all_variants_one)
    v_three.update_proportions
    r.variant_base_id = v_one.id
    
    i_all = [ingredients(:one).id, ingredients(:three).id].sort
    recipe_i = r.ingredients_all_variants.pluck(:id).sort
    
    assert recipe_i == i_all, 'ingredients_all_variants are not goods : ' + recipe_i.to_s + ' vs ' + i_all.to_s
    
  end
  
end
