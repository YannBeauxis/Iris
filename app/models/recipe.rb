class Recipe < ActiveRecord::Base
  has_and_belongs_to_many :ingredients, -> { uniq }
  has_many :variants, :class_name => 'Variant', :foreign_key => 'recipe_id'
  has_many :products, through: :variants
  belongs_to :type, :class_name => 'RecipeType', :foreign_key => 'recipe_type_id'
  validates :type, :name, presence: true

  def ingredient_types
    IngredientType.joins(ingredients: :recipes).where('recipe_id = '+ self.id.to_s).group('ingredient_types.id')
  end

  def ingredient_candidates
    Ingredient.where.not(id: self.ingredients)
              .joins('INNER JOIN ingredient_types ON ingredients.ingredient_type_id = ingredient_types.id')
              .joins('INNER JOIN ingredient_types_recipe_types ON ingredients.ingredient_type_id = ingredient_types_recipe_types.ingredient_type_id')
              .where(ingredient_types_recipe_types: {recipe_type_id: self.type})
  end

end
