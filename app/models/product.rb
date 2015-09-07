class Product < ActiveRecord::Base
  belongs_to :variant
  validates :name, :volume, presence: true
  has_one :recipe, through: :variant  
  
  after_initialize :get_quantities
  
  def get_quantities
    @quantities = ProductQuantity.new(self)
  end
  
  def quantities
    @quantities
  end
  
  def price
    quantities.product_price
  end
     
end
