class Ingredient < ActiveRecord::Base
  has_and_belongs_to_many :recipes, -> { uniq }
  belongs_to :type, :class_name => 'IngredientType', :foreign_key => 'ingredient_type_id'
  has_many :containers, :dependent => :restrict_with_error
  has_many :proportions, as: :composant, :dependent => :restrict_with_error
  has_many :container_references, through: :type
  validates :type, :name, presence: true
  before_destroy :check_for_recipes

  def price_by_unit
   if containers.any? then
    pbu = containers.first.price_by_unit
    self.containers.each { |c| if (pbu.to_f > c.price_by_unit.to_f) then pbu = c.price_by_unit end }
    return pbu
   else 
    return nil
   end
  end

  def volume_in_stock
    vol=0
    self.containers.each { |c| if (not c.volume_actual.nil?) then vol += c.volume_actual end }
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
  
end
