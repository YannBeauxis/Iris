require 'test_helper'

class ContainerReferencesControllerTest < ActionController::TestCase
  test "should get new" do
    sign_in users(:one)
    get :new, :ingredient_type_id => ingredient_types(:one)
    assert_response :success
  end
end
