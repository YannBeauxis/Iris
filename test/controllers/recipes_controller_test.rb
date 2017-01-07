require 'test_helper'

class RecipesControllerTest < ActionController::TestCase

  # check if json response return all expected recipes
  test "index by ajax OLD" do
    u = users(:one)
    sign_in u
    get :index, :format => :json
    assert_response :success
    rl = assigns(:recipes).map { |i| i[:id] }
    rl_model = Recipe.user_enable(u).pluck(:id)
    assert_equal rl.to_set, rl_model.to_set, 
      'Recipe list should be equal to Recipe.user_enable'
  end
  
  # check if json response return all expected recipes
  # json format should be [recipetype_1: {id, ... , recipes: [recipe_1, ...}],recipe_type_2 ...]
  test "index by ajax" do
    u = users(:one)
    sign_in u
    get :index, :format => :json
    assert_response :success
    types_list = assigns(:recipes).map { |t| t[:id] }
    types_target = RecipeType.all.pluck(:id)
  # http://ruby-doc.org/stdlib-1.9.3/libdoc/set/rdoc/Set.html
  # .to_set is used to compare
    assert_equal types_list.to_set, types_target.to_set, 
      'Recipe list should be equal to Recipe.user_enable'
  end

  test "variant_base_user_constraint" do
    u = users(:one)
    sign_in u
    r = recipes(:one)
    v_one = variants(:one)
    v_not_one = variants(:not_one)
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes"
    
    patch(:update, id: r, recipe: {variant_base_id: v_one.id})
    assert_equal r.reload.variant_base_id, v_one.id
    
    patch(:update, id: r, recipe: {variant_base_id: v_not_one.id})
    assert_not_equal r.reload.variant_base_id, v_not_one.id, 
      "should not have variant base which belong to other user"
  end

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
