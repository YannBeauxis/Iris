require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  
  test "Delete with recipe" do
    v = variants(:recipe_delete)
    r = recipes(:variant_delete)
    r.destroy
    assert_not_includes Variant.all, v,
      'Variant should be deleted when its recipe is deleted'
  end
  
  test "Delete ingredient_on_proportion" do
    i = ingredients(:delete_recipe_ingredient)
    v = variants(:delete_recipe_ingredient)
    v.ingredients.destroy(i)
    v.update_proportions
    v.save
    assert v.proportions.count == 2, 
      v.proportions.count.to_s + ' Proportion associated to an ingredient should be deleted when its ingredient is'
  end
  
end