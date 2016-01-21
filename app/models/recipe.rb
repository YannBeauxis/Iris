class Recipe < ActiveRecord::Base
  has_and_belongs_to_many :ingredients, -> { uniq }
  has_many :variants, dependent: :destroy, autosave: :true 
  has_many :products, through: :variants
  belongs_to :type, :class_name => 'RecipeType', :foreign_key => 'recipe_type_id'
  belongs_to :user
  validates :user, :type, :name, presence: true
  after_save :update_proportions

  after_create :variant_base_create

  def variant_base
    Variant.find_by(id: self.variant_base_id)
  end

  def variant_base=(variant)
    self.variant_base_id = variant.id
  end

  def variant_base_create
    v = Variant.create! do |vb|
      vb.name='Base'
      vb.recipe = self
      self.variant_base = vb
    end
    self.save
  end

  def variant_base_set
  # Add variant_base if not exist
    if self.variants.any?
      self.variant_base = self.variants.first
    else
      v = variant_base_create
    end
    self.save
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

  def ingredient_types
    IngredientType.joins(ingredients: :recipes).where('recipe_id = '+ self.id.to_s).group('ingredient_types.id')
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
