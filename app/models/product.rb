class Product < ActiveRecord::Base
  belongs_to :variant
  belongs_to :user
  validates :volume, :user, :variant, :container, presence: true
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

  def consume_stock
    self.variant.ingredients.each do |i|
      quantity = {'ml' => :volume, 'g' => :mass}[i.mesure_unit]
      i.consume_stock(user: self.user, quantity: self.quantities.get(quantity,i))
    end
  end

end
