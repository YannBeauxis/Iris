require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "Add Recipe" do
    r = Recipe.new
    r.name = 'Recipe test'
    r.type = recipe_types(:one)
    assert r.save
  end
  
  test "ingredients_types" do
    r=recipes(:one)
    it = ingredient_types(:one)
    assert_includes r.ingredient_types, it
  end
  
  test "ingredient_candidates_include_already" do
    r=recipes(:ingredient_candidates)
    ic = r.ingredient_candidates
    i = ingredients(:ingredient_candidates_include_already)
    assert_not_includes ic,i, 'ne pas inclure ingrédients déjà dans la recette'
  end
  
  test "ingredient_candidates_include_not_already" do
    r=recipes(:ingredient_candidates)
    ic = r.ingredient_candidates
    i = ingredients(:ingredient_candidates_include_not_already)
    assert_includes ic,i
  end

  test "ingredient_candidates_not_include" do
    r=recipes(:ingredient_candidates)
    ic = r.ingredient_candidates
    i = ingredients(:ingredient_candidates_not_include)
    assert_not_includes ic,i
  end
  
end
