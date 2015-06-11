require 'test_helper'

class IngredientTypeTest < ActiveSupport::TestCase
  
  test "change name" do
    it = ingredient_types(:one)
    it.name = "Huile tout court"
    it.save
    assert it.name == "Huile tout court"
  end
  
  test "respect mesure unit" do
    it = ingredient_types(:one)
    it.mesure_unit = "anything"
    assert_not it.save
  end
  
  test "add ingredient type" do
    it = IngredientType.new
    it.name = "Ingredient Type Name"
    it.name_short = "ITN"
    it.mesure_unit = "ml"
    assert it.save
  end
  
  test "has recipe type" do
    it = ingredient_types(:one)
    rt = recipe_types(:one)
    assert_includes it.recipe_types, rt
  end
  
end
