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

  
end
