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
   assert_not r.shared?,
    'Shared is not false'
   r.shared = true
   r.save
   assert r.shared?
  end
  
  test "ingredients_types" do
    r=recipes(:one)
    it = ingredient_types(:one)
    assert_includes r.ingredient_types, it
  end
  
  test "ingredient_candidates" do
  # For a given recipe, a "compatible ingredient_type" 
  # is an ingredient_type member of the ingredient_types of te recipe_type of this recipe
    r=recipes(:ingredient_candidates)
    ic = r.ingredient_candidates
    iia = ingredients(:ingredient_candidates_include_already)
    assert_not_includes ic,iia, 
      'ingredient already in recipe should not be candidate'
    iina = ingredients(:ingredient_candidates_include_not_already)
    assert_includes ic,iina, 
      'ingredient with compatible ingredient_type and not include already ine the recipe but should be candidate'
    ini = ingredients(:ingredient_candidates_not_include)
    assert_not_includes ic,ini,
      'ingredient with a non compatible ingredient_type should not be candidate'
  end

  test "duplicate_variant" do
    r = recipes(:proportions)
    v_origin = variants(:proportions)
    v_copy = r.duplicate_variant(v_origin,'Copy of variant')
    assert v_copy.name == 'Copy of variant'
    assert_not v_copy == v_origin, "should be a copy, not the original"
    assert_not v_origin.products.blank? , "orgin should have products"
    assert v_copy.products.blank? , "copy should not have products"
    assert v_copy.proportions.count == v_origin.proportions.count, "copy should have same number of proportions"
    v_copy.proportions.each do |p|
      p_origin = v_origin.proportions.find_by(composant: p.composant)
      assert p.value == p_origin.value, 
        "proportions value error : copy = " + p.value.to_s + " vs origin = " + p_origin.value.to_s
    end
  end
  
end
