class Product < ActiveRecord::Base
  belongs_to :variant
  validates :name, :volume, presence: true

  def price
    p = 0
    self.variant.recipe.ingredients.each do |i|
      if i.price_by_unit.nil? then
        return nil
      else
        p += i.price_by_unit * self.variant.composant_proportion(i) * self.variant.composant_proportion(i.type) * self.volume
      end
    end
    return p.round(2)
  end

end
