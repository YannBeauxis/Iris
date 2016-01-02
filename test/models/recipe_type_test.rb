require 'test_helper'

class RecipeTypeTest < ActiveSupport::TestCase
  
  test "Add Recipe Type" do
    r = RecipeType.new
    r.name = 'Recipe Type test'
    assert r.save
  end
  
  test "Not delete if recipes" do
    rt = recipe_types(:three)
    assert_not rt.destroy
  end
  
  test "Density" do
    rt_d_09 = recipe_types(:density_09)
    rt_no_d = recipe_types(:no_density)
    assert rt_d_09.density == 90, 'not get self density'
    assert rt_no_d.density == 100, 'not get default density' 
  end
  
end
