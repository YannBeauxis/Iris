class Product < ActiveRecord::Base
  belongs_to :variant
  validates :name, :volume, presence: true

  def price
    if @product_price.nil? then
      price = 0
    else
    @product_price
    end
  end

  def ingredient_mass(i)
    if @i_mass.nil? then
      ingredient_mass = 0
    else
    @i_mass[i]
    end
  end

  def ingredient_volume(i)
    if @i_volume.nil? then
      ingredient_volume = 0
    else
    @i_volume[i]
    end
  end

  def ingredient_price(i)
    if @i_volume.nil? then
      ingredient_volume = 0
    else
    @i_price[i]
    end
  end

  def evaluate_proportions

     d  = self.variant.recipe.type.density
     v = self.volume
     m = d * v
     
     @i_mass = Hash.new
     @i_volume = Hash.new
     @i_price = Hash.new
     
     p = 0
     p_missing = false
     
     self.variant.ingredients.each do |i|
       p_i = self.variant.composant_proportion(i)*self.variant.composant_proportion(i.type)
       d_i = i.density
       if p_i > 0 then
         m_i = m * p_i
         v_i = m_i / d_i 
       else
         m_i = 0
         v_i = 0       
       end
  
       @i_mass[i] = m_i.round(6)
       @i_volume[i] = v_i.round(6)
       
      if i.price_by_unit.nil? then
        p_missing = true
        @i_price[i] = nil
      else
        if i.type.mesure_unit == 'g' then
            px_i = i.price_by_unit * m_i
        elsif i.type.mesure_unit == 'ml'
            px_i = i.price_by_unit * v_i
        end
        @i_price[i] = px_i.round(6)
        p += px_i         
      end
        
    end
 
    if p_missing then
      @product_price = nil
    else
      @product_price = p.round(2)
    end
   
   evaluate_proportions = true
   end
     
end
