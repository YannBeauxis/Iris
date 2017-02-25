require 'test_helper'

class AdministrationControllerTest < ActionController::TestCase
  
   test "only signed_in can access admin" do
     get :users
     assert_response 302
   end
  
end
