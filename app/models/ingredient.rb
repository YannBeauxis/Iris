class Ingredient < ActiveRecord::Base
  has_and_belongs_to_many :recipes, -> { uniq }
  belongs_to :type, :class_name => 'IngredientType', :foreign_key => 'ingredient_type_id'
  has_many :containers, :dependent => :restrict_with_error
  has_many :proportions, as: :composant, :dependent => :restrict_with_error
  has_many :container_references, through: :type
  validates :type, :name, presence: true
  before_destroy :check_for_recipes

  def recipes_count(*user)
    if user.any? then
      result = self.recipes.where(user: user).count
    else
      result = self.recipes.count
    end
    if result == 0 then
      result = nil
    end
    return result
  end

  def price_by_unit_display
    pbu = self.price_by_unit
    if pbu.present? then
      unit = self.type.mesure_unit
      if unit == 'ml' then 
        pbu = pbu*1000 
        unit = 'l'
      end
      return pbu.display.to_s + ' €/' + unit
    end
  end

  def price_by_unit
   if containers.any? then
    pbu = containers.first.price_by_unit
    self.containers.each { |c| if (pbu.to_f > c.price_by_unit.to_f) then pbu = c.price_by_unit end }
    return pbu
   else 
    return nil
   end
  end

  def quantity_in_stock(user)
    vol=0
    self.containers.each { 
      |c| if (not c.volume_actual.nil? and c.user == user) then vol += c.volume_actual end }
    if vol == 0 then
      vol = nil
    end
    return vol
  end

  def check_for_recipes
    if recipes.count > 0
      errors[:base] << "cannot delete customer while receipes use this ingredient"
      return false
    end
  end

# density equal ingredient type density by default
  def density
    if super.nil? then
      self.type.density
    else
      super
    end
  end
  
  def proportion_variant(variant)
    p = Proportion.find_by(variant: variant, composant: self)
    return (p.value*100).to_s + '%'
  end
  
  def product_mass(product)
    product.ingredient_mass(self).display
  end

  def product_mass_display(product)
    product_mass(product).to_s + ' g'
  end

  def product_volume(product)
    product.ingredient_volume(self).display
  end
  
  def product_volume_display(product)
    vol = product_volume(product)
    if vol>=2 then
      return vol.to_s + ' ml'
    end
  end

  def product_quantity(product)
    vol = product_volume(product)
    if self.type.name_short == 'HE' then
      return (vol*35).round(0).to_s + ' gt.'
    end
  end
  
end
