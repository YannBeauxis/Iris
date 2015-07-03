class IngredientType < ActiveRecord::Base
  has_many :ingredients, :dependent => :restrict_with_error
  has_and_belongs_to_many :recipe_types
  has_many :proportions, as: :composant
  validates :name,:name_short, presence: true
  validates :mesure_unit , inclusion: { in: %w(ml g),
    message: "%{value} is not a valid volmue unit" }, allow_nil: false
    
# density equal 1 by default
  def density
    if super.nil? then
      1
    else
      super
    end
  end
    
end
