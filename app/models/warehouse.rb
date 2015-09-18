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
  
  def quantity_for_ingredient(ingredient)
    l = @list.where('ingredient_id = ?', ingredient)
    vol=0
    l.each { 
      |c| if (not c.volume_actual.nil?) then vol += c.volume_actual end }
    if vol == 0 then
      vol = nil
    end
    return vol
  end
  
end