require 'test_helper'

class ContainerTest < ActiveSupport::TestCase
  
  test "add container" do
    c = Container.new
    c.ingredient = ingredients(:one)
    c.user = users(:one)
    c.quantity_init = 10
    c.price = 5
    assert c.save
  end
  
  test "price by unit" do
    c = containers(:one)
    assert c.price_by_unit == 0.5, c.price_by_unit
  end
  
  test "mass empty" do
    hcr = containers(:has_container_reference)
    nhcr = containers(:not_has_container_reference)
    assert hcr.mass_empty == 5, hcr.mass_empty
    assert nhcr.mass_empty.blank?, nhcr.mass_empty
  end

  test "mass total" do
    hcr = containers(:has_container_reference)
    nhcr = containers(:not_has_container_reference)
    assert hcr.mass_total == 29, hcr.mass_total
    assert nhcr.mass_total.blank?, nhcr.mass_total
  end

  test "update with mass" do
    c = containers(:update_with_mass)
    c.update_with_mass(20)
    assert c.quantity_actual == 12.5, c.quantity_actual
  end

  test "not update with mass if mass < mass_empty" do
    c = containers(:update_with_mass)
    c.update_with_mass(2)
    assert c.quantity_actual == 20, c.quantity_actual
  end

end
