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

  
  test "not delete if ingredient associated" do
    i = ingredients(:two)
    it = ingredient_types(:two)
    assert_not it.destroy
  end
  
  test "density" do
    it_has_density = ingredient_types(:one)
    it_no_density = ingredient_types(:no_density)   
    assert it_has_density.density == 120, 'Not get self density'
    assert it_no_density.density == 100, 'Not get default density'
  end
  
end
