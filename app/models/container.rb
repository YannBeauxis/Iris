class Container < ActiveRecord::Base
  belongs_to :ingredient
  validates :ingredient, :volume_init, :price, presence: true
  validates :volume_init, :numericality => { :greater_than => 0 }
  #, :volume_actual

  def price_by_unit

     pbu  =  price / volume_init

     return pbu

  end

end
