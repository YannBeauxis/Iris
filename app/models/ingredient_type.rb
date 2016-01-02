class IngredientType < ActiveRecord::Base
  has_many :ingredients, :dependent => :restrict_with_error
  has_and_belongs_to_many :recipe_types
  has_many :proportions, as: :composant
  has_many :container_references, dependent: :destroy
  validates :name,:name_short, presence: true
  validates :mesure_unit , inclusion: { in: %w(ml g),
    message: "%{value} is not a valid volmue unit" }, allow_nil: false
    
# density equal 1 by default
  def density
    if super.nil? or :mesure_unit == 'g' then
      100
    else
      super
    end
  end

  def proportion_variant(variant)
    p = Proportion.find_by(variant: variant, composant: self)
    return (p.value*0.01).to_s + '%'
  end

end
