require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  test "Delete with variant" do
    p = products(:variant_delete)
    v = variants(:product_delete)
    v.destroy
    assert_not_includes Product.all, p
  end
  
  test "Proportions" do
    u = users(:one)
    p = products(:proportions)
    i_1 = ingredients(:proportions_1)
    i_2 = ingredients(:proportions_2)
    i_3 = ingredients(:proportions_3)
    #assert p.evaluate_proportions
    p.quantities.compute_prices(u)
    assert p.quantities.get(:mass,i_1) == 54, 'Mass i_1 = ' + p.quantities.get(:mass,i_1).to_s + ' not 54'
    assert p.quantities.get(:mass,i_2) == 13.5, 'Mass i_2 = ' +p.quantities.get(:mass,i_2).to_s + ' not 13.5'
    assert p.quantities.get(:mass,i_3) == 22.5, 'Mass i_3 = ' +p.quantities.get(:mass,i_3).to_s + ' not 22.5'
    assert p.quantities.get(:volume,i_1) == 67.5, 'volume i_1 = ' + p.quantities.get(:volume,i_1).to_s + ' not 67.5'
    assert p.quantities.get(:volume,i_2) == 11.25, 'volume i_2 = ' + p.quantities.get(:volume,i_2).to_s + ' not 11.25'
    assert p.quantities.get(:volume,i_3) == 18.75, 'volume i_3 = ' + p.quantities.get(:volume,i_3).to_s + ' not 18.75'
    assert p.quantities.get(:price,i_1) == 67.5, 'price i_1 = ' + p.quantities.get(:price,i_1).to_s + ' not 67.5'
    assert p.quantities.get(:price,i_2) == 22.5, 'price i_2 = ' + p.quantities.get(:price,i_2).to_s + ' not 22.5'
    assert p.quantities.get(:price,i_3) == 37.5, 'price i_3 = ' + p.quantities.get(:price,i_3).to_s + ' not 45'
    assert p.price == 127.5, 'price = ' + p.price.to_s + ' not 135'
  end
  
end
