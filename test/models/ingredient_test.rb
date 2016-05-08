require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  
  test "add ingredient" do
    i = Ingredient.new
    i.name = "New Ingredient"
    i.type = ingredient_types(:one)
    assert i.save
  end
  
  test "user visible" do 
    u = users(:one)
    il = Ingredient.user_scope(u)
    i_one_validated = ingredients(:one)
    i_one_not_validated = ingredients(:one_not_validated)
    i_not_one = ingredients(:not_one)
    i_not_one_not_validated = ingredients(:not_one_not_validated)
    assert_includes(il, i_one_validated, 'user scope should include user validated')
    assert_includes(il, i_one_not_validated, 'user scope should include user not validated')
    assert_includes(il, i_not_one, 'user scope should include other user validated')
    assert_not_includes(il, i_not_one_not_validated, 'user scope should not include other user not validated')
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
  
  test "cosume_stock_one_container" do
    u = users(:one)
    i = ingredients(:consume_stock_one_container)
    i.consume_stock(user: u, quantity: 2)
    assert i.quantity_in_stock(u) == 800, i.quantity_in_stock(u)
  end

  test "cosume_stock_many_container" do
    u = users(:one)
    i = ingredients(:consume_stock_many_conainers)
    i.consume_stock(user: u, quantity: 2)
    assert i.quantity_in_stock(u) == 900, i.quantity_in_stock(u)
    
    c_one = containers(:consume_stock_many_conainers_one)
    c_ten = containers(:consume_stock_many_conainers_ten)
    assert c_one.quantity_actual == 0, c_one.quantity_actual
    assert c_ten.quantity_actual == 900, c_ten.quantity_actual
  end

end
