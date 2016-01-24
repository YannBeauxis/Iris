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
  
end
