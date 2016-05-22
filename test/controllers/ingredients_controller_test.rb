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
    il_model = Ingredient.user_enable(u).pluck(:id)
    assert_equal il.to_set, il_model.to_set, 
      'ingredient list should be equal to Ingredient.user_enable'
  end

  test "should get new" do
    sign_in users(:one)
    get :new
    assert_response :success
  end

  test "create ingredient" do
    sign_in users(:one)
    i_type_id = ingredient_types(:one).id
    i_name = "new_ingredient"
    i_name_latin = "nova ingrediento"
    i_description = "Ipsem lorum"
    i_density = 1.10
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients"
    post(:create, ingredient: {
                    ingredient_type_id: i_type_id,
                    name: i_name,
                    name_latin: i_name_latin,
                    description: i_description,
                    density: i_density})
    i = assigns(:ingredient)
    assert_not_nil i , "should create ingredient"
    assert i.ingredient_type_id == i_type_id
    assert i.name == i_name
    assert i.name_latin == i_name_latin
    assert i.description == i_description
    assert i.density == 110, i.density
  end

  test "create ingredient with defaut density" do
    sign_in users(:one)
    i_type_id = ingredient_types(:one).id
    i_name = "new_ingredient"
    i_name_latin = "nova ingrediento"
    i_description = "Ipsem lorum"
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients"
    post(:create, ingredient: {
                    ingredient_type_id: i_type_id,
                    name: i_name,
                    name_latin: i_name_latin,
                    description: i_description})
    i = assigns(:ingredient)
    assert_not_nil i , "should create ingredient"
    assert i.ingredient_type_id == i_type_id
    assert i.name == i_name
    assert i.name_latin == i_name_latin
    assert i.description == i_description
    assert i.density == ingredient_types(:one).density, i.density
  end

  test "should not get index if not signed" do
    get :index
    assert_response 302
  end

  test "ingredient is editable by producteur if not validated" do
    sign_in users(:one)
    i = ingredients(:one_not_validated)
    i_name_updated = "name updated"
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients"
    patch(:update, id: i, ingredient: {name: i_name_updated})
    i = Ingredient.find(i.id)
    assert i.name == i_name_updated, i.name
  end

  test "ingredient is not editable by producteur if validated" do
    sign_in users(:one)
    i = ingredients(:one)
    i_name_updated = "name updated"
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients"
    patch(:update, id: i, ingredient: {name: i_name_updated})
    i = Ingredient.find(i.id)
    assert_not i.name == i_name_updated, i.name
  end
  
end
