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
  
  test "cannot_delete_if_base" do
    u = users(:one)
    r = u.recipes.create! do |ur|
      ur.name = 'Recipe test'
      ur.type = recipe_types(:one)
   end
   v = r.variant_base
   assert_not v.destroy, 'une variant de base ne peut être supprimée'
  end

  test "duplicate_variant" do
    u = users(:one)
    r = recipes(:one)
    v = variants(:one)
    r.variant_base_id = v.id
    v_copy = v.duplicate
    vid = v.ingredients.pluck(:id)
    vcid = v_copy.ingredients.pluck(:id)
    ingredients_diff = (vid - vcid) + (vcid - vid)
    assert ingredients_diff == [], 'les ingrédients dupliqués ne sont pas les mêmes'
  end

end