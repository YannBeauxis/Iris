require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  test "Proportions" do
    u = users(:one)
    p = products(:proportions)
    i_1 = ingredients(:proportions_1)
    i_2 = ingredients(:proportions_2)
    i_3 = ingredients(:proportions_3)
    #assert p.evaluate_proportions
    p.quantities.compute_prices(u)
    assert p.quantities.get(:mass,i_1).round(2) == 55.38, 'Mass i_1 = ' + p.quantities.get(:mass,i_1).to_s + ' not 55.38'
    assert p.quantities.get(:mass,i_2).round(2) == 13.85, 'Mass i_2 = ' + p.quantities.get(:mass,i_2).to_s + ' not 13.85'
    assert p.quantities.get(:mass,i_3).round(2) == 23.08, 'Mass i_3 = ' + p.quantities.get(:mass,i_3).to_s + ' not 23.08'
    assert p.quantities.get(:volume,i_1).round(2) == 69.23, 'volume i_1 = ' + p.quantities.get(:volume,i_1).to_s + ' not 69.23'
    assert p.quantities.get(:volume,i_2).round(2) == 11.54, 'volume i_2 = ' + p.quantities.get(:volume,i_2).to_s + ' not 1.54'
    assert p.quantities.get(:volume,i_3).round(2) == 19.23, 'volume i_3 = ' + p.quantities.get(:volume,i_3).to_s + ' not 19.23'
    assert p.quantities.get(:price,i_1).round(2) == 69.23, 'price i_1 = ' + p.quantities.get(:price,i_1).to_s + ' not 69.23'
    assert p.quantities.get(:price,i_2).round(2) == 23.08, 'price i_2 = ' + p.quantities.get(:price,i_2).to_s + ' not 23.08'
    assert p.quantities.get(:price,i_3).round(2) == 38.46, 'price i_3 = ' + p.quantities.get(:price,i_3).to_s + ' not 38.46'
    assert p.price.round(2) == 130.77, 'price = ' + p.price.to_s + ' not 130.77'
  end
  
end
