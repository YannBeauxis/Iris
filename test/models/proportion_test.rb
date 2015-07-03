require 'test_helper'

class ProportionTest < ActiveSupport::TestCase
  test "Delete with variant" do
    p=proportions(:variant2proportion_delete)
    v = variants(:variant2proportion_delete)
    v.destroy
    assert_not_includes Proportion.all, p
  end
  
end
