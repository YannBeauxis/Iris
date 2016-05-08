require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  
  test "should get index by html" do
    sign_in users(:one)
    get :index
    assert_response :success
  end

  test "index by ajax" do
    u = users(:one)
    sign_in u
    get :index, :format => :json
    assert_response :success
    il = assigns(:ingredients).map { |i| i[:id] }
    il_model = Ingredient.user_scope(u).pluck(:id)
    assert_equal il.to_set, il_model.to_set, 'ingredient list should be equal to Ingredient.user_scope'
  end

  test "should get new" do
    sign_in users(:one)
    get :new
    assert_response :success
  end


  test "should not get index if not signed" do
    get :index
    assert_response 302
  end

  test "should get edit" do
    u = users(:one)
    sign_in u
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients"
    get :edit, id: u
    assert_response :success
  end

# for fixtures iep means "Ingredient Edited by Producteur"
  test "ingredient is editable if solo use" do
    u = users(:iep_main)
    sign_in u
    i = ingredients(:iep_solo)
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients"
    patch(:update, id: i, ingredient: {name: 'iep_main updated'})
    i = Ingredient.find(i.id)
    assert i.name == 'iep_main updated', i.name
  end

  test "ingredient is not editable if shared use recipe" do
    u = users(:iep_main)
    sign_in u
    i = ingredients(:iep_shared)
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients"
    name = 'iep_shared updated'
    patch(:update, id: i, ingredient: {name: name})
    i = Ingredient.find(i.id)
    assert_not i.name == name, i.name
  end

  test "ingredient is not editable if shared use container" do
    u = users(:iep_main)
    sign_in u
    i = ingredients(:iep_shared_container)
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients"
    patch(:update, id: i, ingredient: {name: 'iep_shared_container updated'})
    i = Ingredient.find(i.id)
    assert_not i.name == 'iep_shared_container updated', i.name
  end
  
end
