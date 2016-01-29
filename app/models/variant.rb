class Variant < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user
  has_and_belongs_to_many :ingredients, -> { uniq }
  has_many :proportions, dependent: :destroy
  has_many :products, dependent: :restrict_with_error
  has_many :ingredient_types, -> { uniq }, through: :ingredients, source: :type
  validates :name, :user, :recipe, presence: true
  after_create :update_proportions
  after_initialize :init_computation
  #after_save :update_proportions
  
  def base?
    if self.recipe.nil?
      false
    else
      self == self.recipe.variant_base
    end
  end
  
  def init_computation
    @computation = ProportionCompute.new(self)
  end

  def update_proportions
    @computation.update
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

  def change_ingredients(options)
  #options : user_id, ingrediens_ids
    v = self
    self.update_proportions
    if !self.same_ingredients?(options[:ingredients_ids])
      if self.has_product?
        v = self.new_version(options)
      else
        if options[:ingredients_ids] == []
          self.ingredients.delete_all
        else
          self.ingredients = Ingredient.find(options[:ingredients_ids])
        end
        self.update_proportions
      end
    end
    v
  end

  def change_proportions(options)
  #options : user_id, ingrediens_ids
    v = self
    self.update_proportions
    if !self.same_proportions?(options[:proportions])
      if self.has_product?
        v = self.new_version(options)
      else
        options[:proportions].each do |p|
          v_p = v.proportions.find_by_id(p[:id])
          v_p.value = p[:value]
          v_p.save
        end
        self.update_proportions
      end
    end
    v
  end

  def same_ingredients?(ingredients_ids)
    sid = self.ingredients.pluck(:id)
    ((sid - ingredients_ids) + (ingredients_ids - sid)) == []
  end

  def same_proportions?(proportions)
    test = true
    proportions.each do |p|
      p_origin = self.proportions.find_by_id(p[:id])#(composant_type: p.composant_type, composant_id: p.composant_id)
      test = (test && (p[:value] == p_origin.value))
    end
    test
  end

  def duplicate(options)
    # create a new variant with the same proportion
    # options :
    #   user_id : id
    #   name: name of new variant
    self.update_proportions
    v_copy = Variant.create! do |v|
      v.name = (options.has_key?(:name) ? options[:name] : ('Copie de ' + self.name))
      v.user = User.find_by_id(options[:user_id])
      v.recipe = self.recipe
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
    #options :
    #   user_id : id
    #   ingredients: [ids, ..]
    #   proportions: [{id: composant id of origin variant, value: value to set to composant of new variant}]
    if !self.archived?
      v_copy = Variant.create! do |v|
        v.name = self.name
        v.user = User.find_by_id(options[:user_id])
        v.recipe = self.recipe
        v.ingredients = options.has_key?(:ingredients_ids) ? Ingredient.find(options[:ingredients_ids]) : self.ingredients
      end
      self.recipe.variant_base_id = v_copy.id if self.base?
      self.recipe.save
      v_copy.update_proportions
      if options.has_key?(:proportions)
        options[:proportions].each do |p|
          # find proportion of origin variant with its id
          p_origin = Proportion.find_by_id(p[:id])
          # find proportion of new variant with same composnat_typ and composant_id than proportion of origin variant
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
      self.next_version_id = v_copy.id
      self.archived = true
      self.save
      v_copy
    end
  end

end
