require 'test_helper'

class ContainerReferenceTest < ActiveSupport::TestCase
  
  test "create container reference" do
    cr = ContainerReference.new
    cr.volume = 30
    cr.mass = 5
    cr.ingredient_type = ingredient_types(:one)
    assert cr.save  
  end
  
  test "sould have ingredient type, volume and mass" do
    cr = ContainerReference.new
    assert_not cr.save
  end
  
  test "Should have ingredient type" do
    cr = ContainerReference.new
    cr.volume = 30
    cr.mass = 5
    assert_not cr.save  
  end
  
  test "Delete with ingredient type" do
    cr = container_references(:delete_with_ingredient_type)
    it = ingredient_types(:delete_container_reference)
    it.destroy
    assert_not_includes ContainerReference.all, cr,
      'container reference should be destroy'
  end
  
end
