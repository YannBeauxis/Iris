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
  
  test "consume_stock" do
    u = users(:one)
    sign_in u
    r = recipes(:consume_stock)
    v = variants(:consume_stock)
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes"
    params = {
      variant_id: v,
      volume: 300,
      container: 'test'
    }
    post(:create, recipe_id: r, product: params)
    i_one = ingredients(:consume_stock_one)
    i_two = ingredients(:consume_stock_two)
    assert i_one.quantity_in_stock(u) == 1000, i_one.quantity_in_stock(u)
    assert i_two.quantity_in_stock(u) == 1000, i_two.quantity_in_stock(u)
    post(:create, recipe_id: r, product: params, consume_stock: true)
    
    i_one = ingredients(:consume_stock_one)
    i_two = ingredients(:consume_stock_two)
    assert i_one.quantity_in_stock(u) == 900, i_one.quantity_in_stock(u)
    assert i_two.quantity_in_stock(u) == 800, i_two.quantity_in_stock(u)
    
  end
  
end
