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

  test "not delete if containers" do
    c = containers(:two)
    i = ingredients(:three)
    assert_not i.destroy
  end
  
  test "not delete if recipe" do
    i = ingredients(:not_delete_if_recipe)
    assert_not i.destroy, 'not delete if recipe associated'
  end
end
