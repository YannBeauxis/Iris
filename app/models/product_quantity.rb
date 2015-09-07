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
  
  def compute_quantities

     d = @product.variant.recipe.type.density
     v = @product.volume
     m = d * v
     
     p = 0
     p_missing = false
     
     @product.variant.ingredients.each do |i|
       p_i = @product.variant.composant_proportion(i)*@product.variant.composant_proportion(i.type)
       d_i = i.density
       if p_i > 0 then
         m_i = m * p_i
         v_i = m_i / d_i 
       else
         m_i = 0
         v_i = 0       
       end
  
       @masses[i] = m_i.round(6)
       @volumes[i] = v_i.round(6)
       
      if i.price_by_unit.nil? then
        p_missing = true
        @prices[i] = nil
      else
        if i.type.mesure_unit == 'g' then
            px_i = i.price_by_unit * m_i
        elsif i.type.mesure_unit == 'ml'
            px_i = i.price_by_unit * v_i
        end
        @prices[i] = px_i.round(6)
        p += px_i         
      end
        
    end
 
    if !p_missing then
    #  @product_price = nil
    #else
      @product_price = p.round(2)
    end
   
   compute_quantities = true
   end
  
end