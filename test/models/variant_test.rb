require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  test "Delete with recipe" do
    v = variants(:recipe_delete)
    r = recipes(:variant_delete)
    r.destroy
    assert_not_includes Variant.all, v
  end
  
  test "create proportion" do
    r = recipes(:create_proportions)
    v = Variant.new
    v.name = "create_proportion"
    r.variants << v
    r.save
    assert v.proportions.count == 6, v.proportions.count
  end
  
  test "Delete recipe ingredient" do
    r = recipes(:delete_recipe_ingredient)
    i = ingredients(:delete_recipe_ingredient)
    v = Variant.new
    v.name = "Delete recipe ingredient"
    r.variants << v
    r.ingredients.delete(i)
    r.save
    assert v.proportions.count == 2, v.proportions.count
  end

  test "proportion sum" do
    r = recipes(:create_proportions)
    v = r.variants.create! do |vr|
      vr.name = "proportion sum"
    end
    s = 0
    v.proportions.all.each { |p| s+=p.value }
    assert s == 3, s
  end
  
end