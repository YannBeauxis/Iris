class Recipe < ActiveRecord::Base
  has_and_belongs_to_many :ingredients, -> { uniq }
  has_many :variants, dependent: :destroy, autosave: :true#, :class_name => 'Variant', :foreign_key => 'recipe_id', 
  has_many :products, through: :variants
  belongs_to :type, :class_name => 'RecipeType', :foreign_key => 'recipe_type_id'
  belongs_to :user
  validates :user, :type, :name, presence: true
  after_save :update_proportions

  def product_count
    self.products.count
  end

  def ingredient_types
    IngredientType.joins(ingredients: :recipes).where('recipe_id = '+ self.id.to_s).group('ingredient_types.id')
  end

  def ingredient_candidates
    Ingredient.where.not(id: self.ingredients)
              .joins('INNER JOIN ingredient_types ON ingredients.ingredient_type_id = ingredient_types.id')
              .joins('INNER JOIN ingredient_types_recipe_types ON ingredients.ingredient_type_id = ingredient_types_recipe_types.ingredient_type_id')
              .where(ingredient_types_recipe_types: {recipe_type_id: self.type})
  end

  def update_proportions
    self.variants.each { |v| v.update_proportions }
  end

  def duplicate_variant(v_origin, name)
    
    v_copy = self.variants.create! do |v|
      v.name = name
    end
   
    v_copy.proportions.each do |p|
      p_origin = v_origin.proportions.find_by(composant: p.composant)
      if p_origin.value == 0 
        #p.value = p_origin.value #Doesn't work, I don't nkow why ... 
                                  #Unbale to reporduct bug with model test.
        p.destroy #if destroy, recreate with update proportion with value = 0
      else
        p.value = p_origin.value
        p.save
      end
    end

    self.save

    return v_copy

  end

end
