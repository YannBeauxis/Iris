class Recipe < ActiveRecord::Base
  #has_and_belongs_to_many :ingredients, -> { uniq }
  has_many :variants, dependent: :destroy, autosave: :true 
  has_many :products, through: :variants
  belongs_to :type, :class_name => 'RecipeType', :foreign_key => 'recipe_type_id'
  belongs_to :user
  validates :user, :type, :name, presence: true
  # I didn't manage to include :variant_base_id on validate
  after_save :check_variant_base_id

  def variant_base
    Variant.find_by(id: self.variant_base_id)
  end

  def variant_base=(variant)
    self.variant_base_id = variant.id
  end

  def check_variant_base_id
    if self.variant_base_id.nil?
      variant_base_set
    end
  end

  def variant_base_set
  # Add variant_base if not exist
    if self.variants.any?
      self.variant_base_id = self.variants.first.id
    else
      variant_base_create
    end
    self.save
  end

  def variant_base_create
    v = Variant.create! do |vb|
      vb.name='Base'
      vb.recipe = self
      vb.user = self.user
    end
    self.variant_base_id = v.id
  end

  def variants_user_scope(user)
    result = []
    self.variants.each do |v|
      test = true
      v.ingredients.each  do |i|
        test = test && ((i.user == user) || i.validated)
      end
      if test && !v.archived?
        result << v
      end
    end
    result
  end

  def user_name
    self.user.name
  end

  def product_count
    self.products.count
  end

  def product_reference
    !self.variant_base.nil? ? self.variant_base.products.first : nil
  end

  def ingredients
    self.variant_base.ingredients
  end

  def ingredients_all_variants
    Ingredient.joins(variants: :recipe).where('recipe_id = ?', self.id).uniq
  end

  def ingredient_types
    IngredientType.joins(ingredients: :variants).where('variant_id = '+ self.variant_base_id.to_s).group('ingredient_types.id')
  end

  def update_proportions
    self.variants.each { |v| v.update_proportions }
  end

end
