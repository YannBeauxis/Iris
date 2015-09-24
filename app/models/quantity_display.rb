class QuantityDisplay
  
  def method_missing(m, value, quantity, ingredient, mode = nil)
    
    if !value.nil? then
      case quantity 
      when :mass
        display = value.display.to_s + ' g'
      when :volume
        if mode == 'unit'
          if ingredient.type.name_short == 'HE'
            display = (value*35).round(0).to_s + ' gt'
          end     
        else
          display = value.display.to_s + ' ml'  + mode.to_s
        end
      when :price
        display = value.display.to_s + ' €'    
      end
    else
      display = nil
    end
        
    return display
    
  end
  
end