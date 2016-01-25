require 'test_helper'

class VariantsControllerTest < ActionController::TestCase

  test "update_variant_name" do
    u = users(:producteur)
    sign_in u
    v = variants(:proportions)
    r = v.recipe
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes/" + r.id.to_s + "/variants"
    patch(:update, {id: v, recipe_id: r, variant: {name: 'Name updated'}})
    v = Variant.find(v.id)
    assert v.name == 'Name updated', v.name
    #assert_redirected_to recipe_variant_path(v)
  end

  test "update_variant_name_owner_only" do
    u = users(:producteur_2)
    sign_in u
    v = variants(:proportions)
    r = v.recipe
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes/" + r.id.to_s + "/variants"
    patch(:update, {id: v, recipe_id: r, variant: {name: 'Name updated 2'}})
    v = Variant.find(v.id)
    assert_not v.name == 'Name updated 2', v.name
    #assert_redirected_to recipe_path(r)
  end
  
  test "duplicate_variant" do
    u = users(:one)
    sign_in u
    v = variants(:one)
    #v.update_proportions
    r = v.recipe
    v_new_name = 'New variant name'
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes/" + r.id.to_s + "/variants"
    post(:duplicate, {variant_id: v, recipe_id: r, variant: {name: v_new_name}})
    v_new = Variant.find_by_id(assigns(:variant).id)
    assert_not v_new.nil?, 'new variant not reachable'
    assert_not v_new == v, 'same variant returned'
    assert v_new.name == v_new_name, 'not new variant name ' + v_new.name
  end

  test "change_ingredients" do
    u = users(:one)
    sign_in u
    r = recipes(:one)
    v_no_p = variants(:change_ingredients_no_product)
    v_no_p.update_proportions
    v_with_p = variants(:change_ingredients_with_product)
    v_with_p.update_proportions

    ingredients_ids = [ingredients(:one).id] 
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes/" + r.id.to_s + "/variants"
    
    # variant with no products associated
    patch(:change_ingredients, {variant_id: v_no_p, recipe_id: r, ingredients_ids: ingredients_ids})
    v_updated = Variant.find_by_id(assigns(:variant).id)
    assert_not v_updated.nil?, 'new variant not reachable'
    assert v_updated == v_no_p, 'not the same variant returned'
    assert v_updated.ingredients.pluck(:id).sort == ingredients_ids.sort, 'not the right ingredients ids'
    
    # variant with products associated
    patch(:change_ingredients, {variant_id: v_with_p, recipe_id: r, ingredients_ids: ingredients_ids})
    v_updated = Variant.find_by_id(assigns(:variant).id)
    assert_not v_updated.nil?, 'new variant not reachable'
    assert_not v_updated == v_with_p, 'the same variant is returned'
    assert v_updated.ingredients.pluck(:id).sort == ingredients_ids.sort, 'not the right ingredients ids'
    v_with_p = Variant.find_by_id(v_with_p.id)
    assert v_with_p.next_version_id == v_updated.id, 'next version not set'
    
  end

  test "change_proportions" do
    u = users(:one)
    sign_in u
    r = recipes(:one)
    v_no_p = variants(:change_proportions_no_product)
    v_no_p.update_proportions
    v_no_p = Variant.find_by_id(v_no_p.id)
    v_with_p = variants(:change_proportions_with_product)
    v_with_p.update_proportions
    v_with_p = Variant.find_by_id(v_with_p.id)
    
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes/" + r.id.to_s + "/variants"
    
    # variant with no products associated
    proportions = v_no_p.proportions.map do |p| 
      p_value = (p.composant_id == ingredients(:three).id ? 500 : p.value)
      {id: p.id, value: p_value}
    end
    patch(:change_proportions, {variant_id: v_no_p, recipe_id: r, proportions: proportions})
    v_updated = Variant.find_by_id(assigns(:variant).id)
    assert_not v_updated.nil?, 'new variant not reachable'
    assert v_updated == v_no_p, 'not the same variant returned'
    test_prop_one = v_updated.proportions.find_by(composant_type: 'Ingredient', composant_id: ingredients(:one).id).value
    assert test_prop_one == 9090, test_prop_one
    test_prop_three = v_updated.proportions.find_by(composant_type: 'Ingredient', composant_id: ingredients(:three).id).value
    assert test_prop_three == 909, test_prop_three
    
    # variant with products associated
    proportions = v_with_p.proportions.map do |p| 
      p_value = (p.composant_id == ingredients(:three).id ? 500 : p.value)
      {id: p.id, value: p_value}
    end
    patch(:change_proportions, {variant_id: v_with_p, recipe_id: r, proportions: proportions})
    v_updated = Variant.find_by_id(assigns(:variant).id)
    assert_not v_updated.nil?, 'new variant not reachable'
    assert_not v_updated == v_with_p, 'the same variant is returned'
    test_prop_one = v_updated.proportions.find_by(composant_type: 'Ingredient', composant_id: ingredients(:one).id).value
    assert test_prop_one == 9090, test_prop_one
    test_prop_three = v_updated.proportions.find_by(composant_type: 'Ingredient', composant_id: ingredients(:three).id).value
    assert test_prop_three == 909, test_prop_three
    v_with_p = Variant.find_by_id(v_with_p.id)
    assert v_with_p.next_version_id == v_updated.id, 'next version not set'
    
  end

end