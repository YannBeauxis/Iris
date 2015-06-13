require 'test_helper'

class ContainerTest < ActiveSupport::TestCase
  test "add container" do
    c = Container.new
    c.ingredient = ingredients(:one)
    c.user = users(:one)
    c.volume_init = 10
    c.price = 5
    assert c.save
  end
  
  test "price by unit" do
    c = containers(:one)
    assert c.price_by_unit == 0.5, c.price_by_unit
  end
  
end
