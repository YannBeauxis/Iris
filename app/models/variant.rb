class Variant < ActiveRecord::Base
  belongs_to :recipe
  has_many :proportions, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :ingredients, through: :recipe
  has_one :user, through: :recipe  
  validates :name, presence: true
  after_create :update_proportions

  def proportions_for_type(type)

    return Proportion.where('variant_id = ' + self.id.to_s)
                   .joins(variant: :ingredients)
                   .where(composant_type: 'Ingredient')
                   .where('ingredients.id = composant_id')
                   .where('ingredients.ingredient_type_id = ' + type.id.to_s)
  end

  def clean_proportion
    self.proportions.each do |p|
      if p.composant.nil? then self.proportions.delete(p) end
    end
  end

  def update_proportions
  #Create new proportions
    [self.recipe.ingredient_types, self.recipe.ingredients].each do |c|
      c.each do |it|
        if self.proportions.find_by(composant: it).nil?
          #p = Proportion.new
          #p.composant = it
          #p.value = 0
          #self.proportions << p
          self.proportions.create! do |p|
            p.composant = it
            p.value = 0
          end
        end
      end
    end
  #Remove proportions with composant no longer in recipe
    dic_composant_type = {'Ingredient' => self.recipe.ingredients, 'IngredientType' => self.recipe.ingredient_types}
    self.proportions.each do |p|
    type_list = dic_composant_type[p.composant_type]
      if type_list.find_by(id: p.composant.id).nil? then
        self.proportions.delete(p)
      end
    end
    self.save
    self.normalize_proportion
  end

  def normalize_proportion
    # Ingredient types
      pt = Proportion.where('variant_id = ' + self.id.to_s)
                 .where(composant_type: 'IngredientType')
      pt_count = pt.count
      if pt_count>0 then
        pt_sum=0
        pt.each { |p| pt_sum += p.value }
        pt.each do |p| 
          if pt_sum == 0 then
            p.value = 1.0/pt_count
          else
            p.value = p.value/pt_sum
          end
          p.value = p.value.round(3)
          p.save
        end
      end

    # Ingredients
      self.recipe.ingredient_types.each do |it|
        pi = Proportion.where('variant_id = ' + self.id.to_s)
                   .joins(variant: :ingredients)
                   .where(composant_type: 'Ingredient')
                   .where('ingredients.id = composant_id')
                   .where('ingredients.ingredient_type_id' => it)
        pi_count = pi.count
        if pi_count>0 then
          pi_sum=0
          pi.each { |p| pi_sum += p.value }
          pi.each do |p| 
            if pi_sum == 0 then
              p.value = 1.0/pi_count
            else
              p.value = p.value/pi_sum
            end
              p.value = p.value.round(3)
              p.save
          end
        end
      end
    self.save
  end

  def composant_proportion(c)
    return self.proportions.where(composant_type: c.class.name).find_by(composant: c).value 
  end

end
