require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  test "add ingredient" do
    i = Ingredient.new
    i.name = "New Ingredient"
    i.ingredient_type_id = 1
    assert i.save
  end
  
  test "exist ingredient 2" do
    i = Ingredient.find(2)
    assert_includes Ingredient.all, i
  end
  
  test "delete with ingredient type" do
    i = Ingredient.find(2)
    it = IngredientType.find(2)
    it.destroy
    assert_not_includes Ingredient.all, i
  end
end
