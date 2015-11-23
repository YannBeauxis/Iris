class Warehouse
  
  def initialize(scope, option = {})
    @containers = case scope 
            when 'user'
              u = option[:user]
              Container.where('user_id = ?', u)
            when 'ingredient_for_user'
              u = option[:user]
              i = option[:ingredient]
              u.warehouse.list.where('ingredient_id = ?', i)
            end
  end
  
  def list
    @containers
  end
  
  def quantity_sum
    vol = @containers.reduce(0) { |v, c|
      v + (c.quantity_actual || 0)
    }
    vol == 0 ? nil : vol
  end
  
  def price_by_unit
   if @containers.any? then
    pbu = @containers.first.price_by_unit
    @containers.each { |c| if (pbu.to_f > c.price_by_unit.to_f) then pbu = c.price_by_unit end }
    return pbu
   else 
    return nil
   end
  end
  
end