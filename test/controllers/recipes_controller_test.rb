require 'test_helper'

class RecipesControllerTest < ActionController::TestCase

  test "update_recipe_name" do
    u = users(:producteur)
    sign_in u
    r = recipes(:proportions)
    r.variant_base_id = variants(:proportions).id
    r.save
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

  test "ingredients_in_variants_base_at_creation" do
    u = users(:producteur)
    sign_in u
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes"
    ingredients_ids = [ingredients(:one).id, ingredients(:three).id]
    post(:create, {
                    recipe: {
                      name: 'New recipe', 
                      recipe_type_id: recipe_types(:one).id
                    },
                    ingredients_ids: ingredients_ids
                  })
    r = assigns(:recipe)
    assert_not r.variant_base_id.nil?
    assert r.variant_base.ingredients.count == 2, r.variant_base.ingredients.count
    assert r.variant_base.proportions.count == 3, r.variant_base.proportions.count.to_s
    assert r.variant_base.proportions.first.value > 0, r.variant_base.proportions.first.value.to_s
  end

#  test "duplicate_variant" do
#    u = users(:admin)
#    sign_in u
#    r = recipes(:proportions)
#    v_origin = variants(:proportions)
#    @request.headers["HTTP_REFERER"] = "http://test.host/recipes"
#    get :duplicate_variant,
#        variant_id: v_origin.id, variant_name: 'Copy of variant',
#        recipe_id: r.id
#    v_copy = Variant.find_by_name('Copy of variant')
#    assert_not v_copy.nil?
#    assert_redirected_to recipe_variant_path(r, v_copy)
#  end

  test "show_recipe" do
    u = users(:one)
    sign_in u
    r = recipes(:one)
    r.variant_base_id = variants(:one).id
    r.save
    get :show, id: r.id
    assert_response :success
  end

end
