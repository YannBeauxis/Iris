require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  test "Delete with variant" do
    p=products(:variant_delete)
    v = variants(:product_delete)
    v.destroy
    assert_not_includes Product.all, p
  end
  
end
