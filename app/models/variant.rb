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

  def compare_ingredients(ingredients_id)
    sid = self.ingredients.pluck(:id)
    ((sid - ingredients_id) + (ingredients_id - sid)) == []
  end

  def compare_proportions(proportions)
    test = true
    proportions.each do |p|
      p_origin = self.proportions.find_by_id(p[:id])#(composant_type: p.composant_type, composant_id: p.composant_id)
      test = (test && (p[:value] == p_origin.value))
    end
    test
  end

  def duplicate
    v_copy = Variant.create! do |v|
      v.name = self.name
      v.ingredients = self.ingredients
    end
    v_copy.update_proportions
    v_copy.proportions.each do |p|
      p_origin = self.proportions.find_by(composant_type: p.composant_type, composant_id: p.composant_id)
      p.value = p_origin.value
      p.save
    end
    v_copy.update_proportions
    v_copy
  end

  def has_product?
    self.products.any?
  end

  def new_version(options)
    if !self.archived?
      v_copy = Variant.create! do |v|
        v.name = self.name
        v.ingredients = options.has_key?(:ingredients) ? Ingredient.find(options[:ingredients]) : self.ingredients
      end
      v_copy.update_proportions
      if options.has_key?(:proportions)
        options[:proportions].each do |p|
          p_origin = Proportion.find_by_id(p[:id])
          vcp = v_copy.proportions.find_by(composant_type: p_origin.composant_type, composant_id: p_origin.composant_id)
          if !vcp.nil?
            vcp.value = p[:value]
            vcp.save
          end
        end
      else
        v_copy.proportions.each do |p|
          p_origin = self.proportions.find_by(composant_type: p.composant_type, composant_id: p.composant_id)
          p.value = p_origin.nil? ? 0 : p_origin.value
          p.save
        end
      end
      v_copy.update_proportions
      self.archived = true
      self.save
      v_copy
    end
  end

end
