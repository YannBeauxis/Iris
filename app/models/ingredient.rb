class Ingredient < ActiveRecord::Base
  has_and_belongs_to_many :recipes, -> { uniq }
  belongs_to :type, :class_name => 'IngredientType', :foreign_key => 'ingredient_type_id'
  has_many :containers, dependent: :destroy
  has_many :proportions, as: :composant
  validates :type, :name, presence: true

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

end
