require 'test_helper'

class ProductsControllerTest < ActionController::TestCase

  test 'product_index_for_recipe_only' do
    u = users(:one)
    sign_in u
    r = recipes(:product_index)
    #@request.headers["HTTP_REFERER"] = "http://test.host/recipes/" + r.id.to_s + '/'
    get :index, recipe_id: r.id
    assert_response :success
    products = JSON.parse(@response.body)
    assert products.length == 1, 'products.length = ' + products.length.to_s + ' instead of 1'
  end
end
