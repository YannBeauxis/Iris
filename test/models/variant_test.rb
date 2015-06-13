require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  test "Delete with recipe" do
    v = variants(:recipe_delete)
    r = recipes(:variant_delete)
    r.destroy
    assert_not_includes Variant.all, v
  end
end
