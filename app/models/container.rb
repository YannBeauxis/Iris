class Container < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :user
  validates :ingredient, :user, :volume_init, :price, presence: true
  validates :volume_init, :numericality => { :greater_than => 0 }
  #, :volume_actual

  def mass_net
    if !self.volume_actual.blank?
      self.ingredient.density * self.volume_actual
    end
  end

  def mass_empty
    self.ingredient.container_references.each do |cr|
      if self.volume_init == cr.volume
        return cr.mass
      end
    end
    return nil
  end

  def mass_total
    mass_net + mass_empty if !mass_empty.nil?
  end

  def update_with_mass(mass)
    if !mass_empty.nil? && mass >= mass_empty
      self.volume_actual = ((mass - mass_empty)/self.ingredient.density).round(1)
      self.save
    end
  end

  def price_by_unit
    self.price / self.volume_init
  end

end
