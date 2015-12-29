class Container < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :user
  validates :ingredient, :user, :quantity_init, :price, presence: true
  validates :quantity_init, :numericality => { :greater_than => 0 }

  def mass_net
    if !self.quantity_actual.blank?
      self.ingredient.density * self.quantity_actual
    end
  end

  def mass_empty
    self.ingredient.container_references.each do |cr|
      if self.quantity_init == cr.volume
        return cr.mass
      end
    end
    return nil
  end

  def mass_total
    mass_net + mass_empty if !mass_empty.nil? && !mass_net.nil?
  end

  def update_with_mass(mass)
    if !mass_empty.nil? && mass >= mass_empty
      self.quantity_actual = ((mass - mass_empty)/self.ingredient.density).round(1)
      self.save
    end
  end

  def price_by_unit
    self.price / self.quantity_init
  end

end
