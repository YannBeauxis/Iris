require 'test_helper'

class RecipesControllerTest < ActionController::TestCase

  test "update_recipe_name" do
    u = users(:producteur)
    sign_in u
    r = recipes(:proportions)
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes"
    patch(:update, id: r, recipe: {name: 'Name updated'})
    r = Recipe.find(r.id)
    assert r.name == 'Name updated', r.name
    assert_redirected_to recipe_path(r)
  end

  test "update_recipe_name_owner_only" do
    u = users(:producteur_2)
    sign_in u
    r = recipes(:proportions)
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes"
    patch(:update, id: r, recipe: {name: 'Name updated 2'})
    r = Recipe.find(r.id)
    assert_not r.name == 'Name updated 2', r.name
    #assert_redirected_to recipe_path(r)
  end

  test "duplicate_variant" do
    u = users(:admin)
    sign_in u
    r = recipes(:proportions)
    v_origin = variants(:proportions)
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes"
    get :duplicate_variant,
        variant_id: v_origin.id, variant_name: 'Copy of variant',
        recipe_id: r.id
    v_copy = Variant.find_by_name('Copy of variant')
    assert_not v_copy.nil?
    assert_redirected_to recipe_variant_path(r, v_copy)
  end
  
  test "create_variant_base_at_creation" do
    u = users(:producteur)
    sign_in u
    r = Recipe.create! do |rn|
      rn.name = 'Auto Variant'
      rn.user = u
      rn.type = recipe_types(:one)
    end
    
    assert r.variants.count > 0, 'Variant base not created at recipe creation'
    
  end
  
  test "show_recipe" do
    u = users(:one)
    sign_in u
    r = recipes(:one)
    get :show, id: r.id
    assert_response :success
  end

  test "get_ingredients_candidates" do
    u = users(:one)
    sign_in u
    r = recipes(:one)
    get :ingredient_candidates, recipe_id: r.id
    assert_response :success
  end

end
