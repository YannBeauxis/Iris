class ProportionCompute

  def initialize(variant)
    @variant = variant
  end

  def update
  #Create new proportions
    [@variant.recipe.ingredient_types, @variant.recipe.ingredients].each do |c|
      c.each do |it|
        if @variant.proportions.find_by(composant: it).nil?
          @variant.proportions.create! do |p|
            p.composant = it
            p.value = 0
          end
        end
      end
    end
    
  #Remove proportions with composant no longer in recipe
    dic_composant_type = {'Ingredient' => @variant.recipe.ingredients, 'IngredientType' => @variant.recipe.ingredient_types}
    @variant.proportions.each do |p|
    type_list = dic_composant_type[p.composant_type]
      if type_list.find_by(id: p.composant.id).nil? then
        @variant.proportions.delete(p)
      end
    end
    @variant.save
    self.normalize
  end

  def normalize
    # Ingredient types
      pt = Proportion.where('variant_id = ' + @variant.id.to_s)
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
      @variant.recipe.ingredient_types.each do |it|
        pi = Proportion.where('variant_id = ' + @variant.id.to_s)
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
    @variant.save
  end


end