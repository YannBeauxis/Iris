require 'test_helper'

class RecipeTypeTest < ActiveSupport::TestCase
  test "Add Recipe Type" do
    r = RecipeType.new
    r.name = 'Recipe Type test'
    assert r.save
  end
end
