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

  test "user_visible" do
    u = users(:one)
    
    r_one = recipes(:one)
    v_not_one = variants(:not_one)
    v_one_ingredient_not_validated = variants(:one_ingredient_not_validated)
    variants_one = r_one.variants_user_scope(u)
    assert_includes variants_one, v_not_one, 
      'should include other user variant if ingredients validated'
    assert_includes variants_one, v_one_ingredient_not_validated, 
      'should include current user variant with ingredients not validated'
    
    v_recipe_not_one = variants(:recipe_not_one)
    v_recipe_not_one_ingredient_not_validated = variants(:recipe_not_one_ingredient_not_validated)
    r_not_one = recipes(:not_one)
    variants_not_one = r_not_one.variants_user_scope(u)
    assert_includes variants_not_one, v_recipe_not_one, 
      'should include other user variant if ingredients validated'
    assert_not_includes variants_not_one, v_recipe_not_one_ingredient_not_validated, 
      'should not include other user variant if ingredients not validated'

  end

  test "duplicate_variant" do
    u = users(:one)
    r = recipes(:one)
    v = variants(:duplicate_variant)
    r.variant_base_id = variants(:one).id

    v.update_proportions
    prop = v.proportions.find_by(composant_id: ingredients(:three).id)
    prop.value = 20000
    prop.save
    v.update_proportions
    
    v_name = 'new variant'
    v_copy = v.duplicate(user_id: u.id, name: v_name)
    
    assert v_copy.name == v_name
    assert v_copy.recipe == v.recipe, 'recipe not set'
    #test ingredients
    vid = v.ingredients.pluck(:id)
    vcid = v_copy.ingredients.pluck(:id)
    ingredients_diff = (vid - vcid) + (vcid - vid)
    assert ingredients_diff == [], 'les ingrédients dupliqués ne sont pas les mêmes'
    #proprotions composants
    pid = v.proportions.pluck(:composant_id)
    pcid = v_copy.proportions.pluck(:composant_id)
    proportions_diff = (pid - pcid) + (pcid - pid)
    assert proportions_diff == [], 
      'les composants des proportions dupliqués ne sont pas les mêmes ' + proportions_diff.to_s
    #proportions_value
    pvid = v.proportions.order(:composant_type, :composant_id).pluck(:value)
    pvcid = v_copy.proportions.order(:composant_type, :composant_id).pluck(:value)
    assert pvid == pvcid, pvid.to_s + ' vs ' + pvcid.to_s
  end

  test "same_ingredients" do
    u = users(:one)
    r = recipes(:one)
    v = variants(:duplicate_variant)
    r.variant_base_id = variants(:one).id

    ingredients_ok = [
      ingredients(:one).id,
      ingredients(:three).id
    ]
    assert v.same_ingredients?(ingredients_ok)
    
    ingredients_nok = [
      ingredients(:one).id
    ]
    assert_not v.same_ingredients?(ingredients_nok)

  end

  test "same_proportions" do
    u = users(:one)
    r = recipes(:one)
    r.variant_base_id = variants(:one).id
    v = Variant.find_by_id(variants(:duplicate_variant).id)
    v.update_proportions
    v = Variant.find_by_id(v.id)
    
    prop_ok = v.proportions.map { |p| {id: p.id, value: p.value} }

    assert v.same_proportions?(prop_ok)
    
    prop_nok = prop_ok
    prop_nok[1][:value] = prop_ok[1][:value] +1

    
    assert_not v.same_proportions?(prop_nok)    

  end

  test "new version" do
    u = users(:one)
    r = recipes(:one)
    v_base = Variant.find_by_id(variants(:duplicate_variant_base).id)
    r.variant_base_id = v_base.id
    r.save
    v = Variant.find_by_id(variants(:duplicate_variant).id)
    v.update_proportions
    v = Variant.find_by_id(v.id)

    #proportions_value

    proportions = v.proportions.map do |p| 
      p_value = (p.composant_id == ingredients(:three).id ? 500 : p.value)
      {id: p.id, value: p_value}
    end

    v_new = v.new_version(proportions: proportions, user_id: u.id)
    v = Variant.find_by_id(v.id)
    
    assert v != v_new
    assert v_new.recipe == v.recipe, 'recipe not set'
    assert v.archived?, 'old version not archived'
    assert v.next_version_id == v_new.id, 'next version id not set'
    assert v_new.user == v.user, 'user not the same'

    v_new = Variant.find_by_id(v_new.id)
    
    test_prop_one = v_new.proportions.find_by(composant_type: 'Ingredient', composant_id: ingredients(:one).id).value
    test_prop_three = v_new.proportions.find_by(composant_type: 'Ingredient', composant_id: ingredients(:three).id).value

    assert test_prop_one == 9090, test_prop_one
    assert test_prop_three == 909, test_prop_three
    
    #test ingredients
    vid = [ingredients(:one).id]
    v_new_2 = v_new.new_version(ingredients_ids: vid, user_id: u.id)
    vcid = v_new_2.ingredients.pluck(:id)
    ingredients_diff = (vid - vcid) + (vcid - vid)
    assert ingredients_diff == [], 'les ingrédients dupliqués ne sont pas les mêmes'

    #change base_id
    r = Recipe.find_by_id(r.id)
    assert r.variant_base_id == v_base.id, 'base is not old version before change'
    
    v_new_base = v_base.new_version(ingredients_ids: vid, user_id: u.id)
    v_base = Variant.find_by_id(v_base.id)

    r = Recipe.find_by_id(r.id)
    assert_not r.variant_base_id == v_base.id, 'base is on old version'
    assert r.variant_base_id == v_new_base.id, 'base is not set to new version'
    
  end

  test "not delete if product" do
    v = variants(:variant_with_product)
    assert_not v.destroy, 'should not delete variant with product'
  end
  
end