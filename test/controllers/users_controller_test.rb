require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "admin should modify role params" do
    a = users(:admin)
    ctp = users(:client_to_producteur)
    sign_in a
    @request.headers["HTTP_REFERER"] = "http://test.host/users"
    patch(:update, id: ctp, user: {'role_id' => roles(:producteur)})
    assert_redirected_to users_path
    assert assigns['user'].role.name == 'producteur', assigns['user'].role.name
  end
 
  test "client should modify name params" do
    u = users(:client)
    sign_in u
    @request.headers["HTTP_REFERER"] = "http://test.host/users"
    patch(:update, id: u, user: {'name' => 'Modified 2'})
    assert_redirected_to users_path
    assert assigns['user'].name == 'Modified 2', assigns['user'].name
    u = User.find(u.id)
    assert u.name == 'Modified 2', u.name
  end
 
   test "client should not modify other username params" do
    u = users(:client)
    o = users(:one)
    sign_in u
    @request.headers["HTTP_REFERER"] = "http://test.host/users"
    patch(:update, id: o, user: {'name' => 'Modified 2'})
    assert_redirected_to :back
    assert_not assigns['user'].name == 'Modified 2', assigns['user'].name
  end
 
  test "client should not modify role params" do
    u = users(:client)
    sign_in u
    @request.headers["HTTP_REFERER"] = "http://test.host/users"
    patch(:update, id: u, user: {'role_id' => roles(:producteur)})
    assert_redirected_to :back
    assert_not assigns['user'].role.name == 'producteur', assigns['user'].role.name
  end

end
