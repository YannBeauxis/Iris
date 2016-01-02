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
  
  test "density" do
    i_no = ingredients(:no_density)
    i_2 = ingredients(:density_2)
    it = ingredient_types(:one)
    assert i_no.density == it.density, i_no.density.to_s + ' no get ingredient type density if not have self density'
    assert i_2.density == 200, 'no get self density'
  end
  
  test "Container reference" do
    hcr = ingredients(:has_container_reference)
    nhcr = ingredients(:not_has_container_reference)
    assert_not hcr.container_references.blank?, hcr.container_references.count
    assert nhcr.container_references.blank?, nhcr.container_references.count
  end
end
