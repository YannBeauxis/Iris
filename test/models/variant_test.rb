require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  
  test "Delete with recipe" do
    v = variants(:recipe_delete)
    r = recipes(:variant_delete)
    r.destroy
    assert_not_includes Variant.all, v,
      'Variant should be deleted when its recipe is deleted'
  end
  
  test "Delete recipe ingredient" do
    r = recipes(:delete_recipe_ingredient)
    i = ingredients(:delete_recipe_ingredient)
    v = r.variants.create do |vr|
      vr.name = "Delete recipe ingredient"
      vr.ingredients = r.ingredients
    end
    v.ingredients.destroy(i)
    v.update_proportions
    v.save
    assert v.proportions.count == 2, 
      v.proportions.count.to_s + ' Proportion associated to an ingredient should be deleted when its ingredient is'
  end

  test "Create proportion" do
    r = recipes(:create_proportions)
    v = r.variants.create! do |vr|
      vr.name = "proportion sum"
      vr.ingredients = r.ingredients
    end
    assert v.proportions.count == 6, 
      'proportions.count error ' + v.proportions.count.to_s
    s = 0
    v.proportions.all.each { |p| s+=p.value }
    assert s == 30000,
      'proportions sum error ' + s.to_s
  end
  
end