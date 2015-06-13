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
  
end
