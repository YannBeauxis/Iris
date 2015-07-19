require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  
  test "should get index" do
    sign_in users(:one)
    get :index
    assert_response :success
  end

  test "should not get index if not signed" do
    get :index
    assert_response 302
  end

  test "should get edit" do
    u = users(:one)
    sign_in u
    get :edit, id: u
    assert_response :success
  end


end
