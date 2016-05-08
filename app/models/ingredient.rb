class Ingredient < ActiveRecord::Base
  #has_and_belongs_to_many :recipes, -> { uniq }
  belongs_to :user
  has_and_belongs_to_many :variants, -> { uniq }
  belongs_to :type, :class_name => 'IngredientType', :foreign_key => 'ingredient_type_id'
  has_many :containers, :dependent => :restrict_with_error
  has_many :proportions, as: :composant, :dependent => :restrict_with_error
  has_many :container_references, through: :type
  validates :type, :name, presence: true

  before_destroy :check_for_variants

  def recipes
    Recipe.joins(variants: :ingredients).where('ingredients.id = ?', self.id).uniq
  end

  def recipes_count(*user)
    if user.any? then
      result = self.recipes.where(user: user).count
    else
      result = self.recipes.count
    end
    if result == 0 then
      result = nil
    end
    return result
  end

  def self.user_scope(user)
    Ingredient.where('user_id = ? or validated = ?', user, true)
  end

  def used_by_other_users?(user)
    (self.recipes.where.not(user: user).count > 0) or (self.containers.where.not(user: user).count > 0)
  end

  def mesure_unit
    self.type.mesure_unit
  end

  def get_warehouse(user)
    @warehouse = Warehouse.new('ingredient_for_user',{user: user, ingredient: self})
  end

  def quantity_in_stock(user)
    self.get_warehouse(user)
    @warehouse.quantity_sum
  end

  def consume_stock(options)
    self.get_warehouse(options[:user])
    @warehouse.consume(options[:quantity])
  end

  def price_by_unit_display(user)
    pbu = self.price_by_unit(user)
    if pbu.present? then
      unit = self.type.mesure_unit
      if unit == 'ml' then 
        pbu = pbu*1000 
        unit = 'l'
      end
      return pbu.display.to_s + ' €/' + unit
    end
  end

  def price_by_unit(user)
    self.get_warehouse(user)
    @warehouse.price_by_unit
  end

  def check_for_variants
    if variants.count > 0
      errors[:base] << "cannot delete while recipes use this ingredient"
      return false
    end
  end

# density equal ingredient type density by default
  def density
    if super.nil? then
      if self.type.nil?
        100
      else
        self.type.density
      end
    else
      super
    end
  end
  
  def proportion_variant(variant)
    p = Proportion.find_by(variant: variant, composant: self)
    return (p.value*0.01).to_s + '%'
  end
  
end
