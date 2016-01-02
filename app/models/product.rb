class Product < ActiveRecord::Base
  belongs_to :variant
  validates :name, :volume, presence: true
  has_one :recipe, through: :variant
  
  def recipe=(r)
    @quantities = nil
    super
  end

  def variant=(v)
    @quantities = nil
    super
  end

  def volume=(v)
    @quantities = nil
    super
  end

  def quantities
    @quantities ||= self.recipe.nil? ? nil : ProductQuantity.new(self)
  end
  
  def price
    quantities.product_price
  end

end
