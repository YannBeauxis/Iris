require 'test_helper'

class UserTest < ActiveSupport::TestCase
   test "add user" do
     u = User.new
     u.email = "iris@test.com"
     u.password = "mdpdeiris"
     assert u.save
   end
end
