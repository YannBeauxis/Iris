require 'test_helper'

class IngredientTypeTest < ActiveSupport::TestCase
  
  test "change name" do
    it = IngredientType.find(1)
    it.name = "Huile tout court"
    it.save
    assert it.name == "Huile tout court"
  end
  
  test "respect mesure unit" do
    it = IngredientType.find(1)
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
end
