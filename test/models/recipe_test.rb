require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "Add Recipe" do
    r = Recipe.new
    r.name = 'Recipe test'
    r.type = recipe_types(:one)
    assert r.save
  end
end
