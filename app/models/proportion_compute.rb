class ProportionCompute

  def initialize(variant)
    @variant = variant
  end

  def update
  #Create new proportions
    [@variant.ingredient_types, @variant.ingredients].each do |c|
      c.each do |it|
        if @variant.proportions.find_by(composant: it).nil?
          @variant.proportions.create! do |p|
            p.composant = it
            p.value = 0
          end
        end
      end
    end
    
  #Remove proportions with composant no longer in variant
    dic_composant_type = {'Ingredient' => @variant.ingredients, 'IngredientType' => @variant.ingredient_types}
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
        pt_sum = 0
        pt.each { |p| pt_sum += p.value }
        pt.each do |p| 
          if pt_sum == 0 then
            p_tmp = 1.0/pt_count
            #p.value = 1.0/pt_count
          else
            p_tmp = p.value*1.0/pt_sum
          end
          #p.value = p.value.round(3)
          p.value = p_tmp*10000.round
          p.save
        end
      end

    # Ingredients
      @variant.ingredient_types.each do |it|
        pi = Proportion.where('proportions.variant_id = ' + @variant.id.to_s)
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
              p_tmp= 1.0/pi_count
            else
              p_tmp = p.value*1.0/pi_sum
            end
              #p.value = p.value.round(3)
              p.value = p_tmp*10000.round
              p.save
          end
        end
      end
    @variant.save
  end


end