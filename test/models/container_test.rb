require 'test_helper'

class ContainerTest < ActiveSupport::TestCase
  test "add container" do
    c = Container.new
    c.ingredient_id = 1
    c.volume_init = 10
    c.price = 5
    assert c.save
  end
  
  test "price by unit" do
    c = Container.find(1)
    assert c.price_by_unit == 0.5, c.price_by_unit
  end
end
