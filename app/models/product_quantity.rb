class ProductQuantity
  def initialize(product)
    @product = product
    @masses = Hash.new
    @volumes = Hash.new
    @prices = Hash.new
    @product_price = nil
    @quantities = {mass: @masses, volume: @volumes, price: @prices}
    self.compute_quantities
    @display = QuantityDisplay.new
  end
  
  def display(quantity,ingredient, mode = nil)
    value = self.get(quantity,ingredient)
    return @display.(value, quantity, ingredient, mode)
  end
  
  def get(quantity,ingredient)
    return @quantities[quantity][ingredient]
  end
  
  def product_price
    @product_price
  end
  
  def product_generator
    variant = @product.variant
    result = {
      id: variant.id,
      name: variant.name,
      archived: variant.archived?,
      base: variant.base?,
      ingredientTypes: {}, 
      ingredients: {}
    }
    variant.ingredient_types.each do |i|
      result[:ingredientTypes][i.id] = {
        proportion: @product.variant.composant_proportion(i)
      }
    end
    @product.variant.ingredients.each do |i|
      result[:ingredients][i.id] = {
        proportion: @product.variant.composant_proportion(i),
        mass: @quantities[:mass][i],
        volume: @quantities[:volume][i],
        price: @quantities[:price][i],
        quantity: conv_to_quantity(i)
      }
    end
    result
  end
  
  def conv_to_quantity(ingredient)
    (@quantities[:volume][ingredient]*35.0) if ingredient.type.name_short == 'HE'
  end
  
  def compute_quantities

     d = @product.recipe.type.density/100.0
     v = @product.volume/100.0
     m = d * v
     v_computed = 0
     
     p = 0
     p_missing = false
     
     @product.variant.ingredients.each do |i|
       p_i = @product.variant.composant_proportion(i)*@product.variant.composant_proportion(i.type)
       d_i = i.density/100.0
       if p_i > 0 then
         m_i = m * p_i * 1.0
         v_i = m_i / d_i
       else
         m_i = 0.0
         v_i = 0.0     
       end
  
       @masses[i] = m_i
       @volumes[i] = v_i
       v_computed += @volumes[i]
          
    end
    
      if v_computed > 0
        @volumes.each{ |key, value| @volumes[key] = (value*v/v_computed).round(6)}
        @masses.each{ |key, value| @masses[key] = (value*v/v_computed).round(6)}
      end
    
  end

  def compute_prices(user)
     
     p = 0
     p_missing = false
     
     @product.variant.ingredients.each do |i|
       
      if i.price_by_unit(user).nil? then
        p_missing = true
        @prices[i] = nil
      else
        if i.type.mesure_unit == 'g' then
            px_i = i.price_by_unit(user) * @masses[i]
        elsif i.type.mesure_unit == 'ml'
            px_i = i.price_by_unit(user) * @volumes[i]
        end
        @prices[i] = px_i.round(6)
        p += px_i         
      end
        
    end

    if !p_missing then
      @product_price = p.round(2)
    end
   
   compute_quantities = true
   end
  
end