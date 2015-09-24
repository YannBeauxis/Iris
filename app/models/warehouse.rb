class Warehouse
  
  def initialize(scope, option = {})
    case scope 
    when 'user'
      u = option[:user]
      @list = Container.where('user_id = ?', u)
    when 'ingredient_for_user'
      u = option[:user]
      i = option[:ingredient]
      @list = u.warehouse.list.where('ingredient_id = ?', i)
    end
  end
  
  def list
    @list
  end
  
  def quantity_sum#_for_ingredient(ingredient)
    #l = @list.where('ingredient_id = ?', ingredient)
    vol=0
    @list.each { 
      |c| if (not c.quantity_actual.nil?) then vol += c.quantity_actual end }
    if vol == 0 then
      vol = nil
    end
    return vol
  end
  
  def price_by_unit
   if @list.any? then
    pbu = @list.first.price_by_unit
    @list.each { |c| if (pbu.to_f > c.price_by_unit.to_f) then pbu = c.price_by_unit end }
    return pbu
   else 
    return nil
   end
  end
  
end