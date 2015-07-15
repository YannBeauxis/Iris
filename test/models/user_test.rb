require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
   test "add user" do
     u = User.new
     #u.name = "New User"
     u.email = "iris@test.com"
     u.password = "mdpdeiris"
     assert u.save
   end
   
  test "Delete container and recipe" do
    u = users(:delete_container_recipe)
    r = recipes(:delete_with_user)
    c = containers(:delete_with_user)
    u.destroy
    assert_not_includes User.all, u
      'User should be destroy'
    assert_not_includes Recipe.all, r,
      'Recipe should be destroy when its user is'
    assert_not_includes Container.all, c, 
      'Container should be destroy when its user is'
  end
   
end
