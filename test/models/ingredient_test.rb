require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  test "add ingredient" do
    i = Ingredient.new
    i.name = "New Ingredient"
    i.type = ingredient_types(:one)
    assert i.save
  end
  
  test "exist ingredient 2" do
    i = ingredients(:two)
    assert_includes Ingredient.all, i
  end
  
  test "delete with ingredient type" do
    i = ingredients(:two)
    it = ingredient_types(:two)
    it.destroy
    assert_not_includes Ingredient.all, i
  end
end
