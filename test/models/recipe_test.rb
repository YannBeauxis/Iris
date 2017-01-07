require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  test "Create Recipe" do
    u = users(:one)
    r = u.recipes.create! do |ur|
      ur.name = 'Recipe test'
      ur.type = recipe_types(:one)
   end
   assert_includes u.recipes, r,
    'Recipe not created'
    assert_not r.variant_base_id.nil?, 'variant base not created'
   assert_not r.shared?,
    'Shared is not false'
   r.shared = true
   r.save
   assert r.shared?
  end


  test "user_enable" do
  # Test if a recipe is user enable if variant base is user enable
    u = users(:one)
    
    #rlist = recipes_user_enable_list
    r_one = recipes(:one)
    r_not_one = recipes(:not_one)
    v_uo_ro_iv = variants(:one)
    v_uo_ro_in = variants(:one_ingredient_not_validated)
    v_un_rn_iv = variants(:recipe_not_one)
    v_un_rn_in = variants(:recipe_not_one_ingredient_not_validated)
    
    # test recipe owned by user is enable
    r_one.variant_base_id = v_uo_ro_iv.id
    r_one.save
    assert_includes Recipe.user_enable(u), r_one
    
    assert_includes Variant.user_enable(u), v_uo_ro_in
    r_one.variant_base_id = v_uo_ro_in.id
    r_one.save
    assert_includes Recipe.user_enable(u), r_one
 
     # test recipe not owned by user
    r_not_one.variant_base_id = v_un_rn_iv.id
    r_not_one.save
    assert_includes Recipe.user_enable(u), r_not_one
    r_not_one.variant_base_id = v_un_rn_in.id
    r_not_one.save
    assert_not_includes Recipe.user_enable(u), r_not_one, 
      "should not enable recipe with variant base not enable"
 
  end

  test "no_delete_variant_base_id" do
    u = users(:one)
    r = u.recipes.create! do |ur|
      ur.name = 'Recipe test'
      ur.type = recipe_types(:one)
   end
   v_id = r.variant_base_id
    r.variant_base_id = nil
    r.save
    assert r.variant_base_id == v_id, 'variant_base_id can\'t be nil'
  end

  test "ingredients_types" do
    r=recipes(:one)
    r.variant_base_id = variants(:one).id
    r.save
    it = ingredient_types(:one)
    assert_includes r.ingredient_types, it
  end
  
  test "ingredients_all_variants" do
    r=recipes(:recipe_ingredients_all_variants)
    v_one = variants(:recipe_ingredients_all_variants_one)
    v_one.update_proportions
    v_three = variants(:recipe_ingredients_all_variants_one)
    v_three.update_proportions
    r.variant_base_id = v_one.id
    
    i_all = [ingredients(:one).id, ingredients(:three).id].sort
    recipe_i = r.ingredients_all_variants.pluck(:id).sort
    
    assert recipe_i == i_all, 'ingredients_all_variants are not goods : ' + recipe_i.to_s + ' vs ' + i_all.to_s
    
  end
  
end
