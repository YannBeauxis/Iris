class Variant < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user
  has_and_belongs_to_many :ingredients, -> { uniq }
  has_many :proportions, dependent: :destroy
  has_many :products, dependent: :destroy
  #has_many :ingredients, through: :recipe
  #has_many :ingredient_types, through: :ingredients, source: :type
  validates :name, presence: true
  after_create :update_proportions
  after_initialize :init_computation
  before_destroy :not_destroy_of_base
  #after_save :update_proportions
  
  def base?
    self == self.recipe.variant_base
  end
  
  def not_destroy_of_base
    if self.base?
      #flash[:message]  << "Une variante de base ne peut être supprimée"
      return false
    end
  end
  
  def init_computation
    @computation = ProportionCompute.new(self)
  end

  def update_proportions
    @computation.update
  end

  def ingredient_types
    IngredientType.joins(ingredients: :variants).where('variants.id' => self).uniq
  end

  def proportions_for_type(type)

    return Proportion.where('proportions.variant_id = ' + self.id.to_s)
                   .joins(variant: :ingredients)
                   .where(composant_type: 'Ingredient')
                   .where('ingredients.id = composant_id')
                   .where('ingredients.ingredient_type_id = ' + type.id.to_s)
  end

  def composant_proportion(c)
    rech = self.proportions.where(composant_type: c.class.name).find_by(composant: c)
     if rech.blank?
       return 0.0
     else
       return rech.value*1.0/(10000)
     end
  end

  def duplicate
    v_copy = Variant.create! do |v|
      v.name = self.name
      v.ingredients = self.ingredients
    end
  end

end
