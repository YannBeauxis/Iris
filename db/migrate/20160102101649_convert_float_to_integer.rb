class ConvertFloatToInteger < ActiveRecord::Migration
  def change
    
    Ingredient.find_each do |i|
      i.density = i.density*100.round if !i.density.nil?
      i.save!
    end
    change_column :ingredients, :density, :int
    
    IngredientType.find_each do |i|
      i.density = i.density*100.round if !i.density.nil?
      i.save!
    end
    change_column :ingredient_types, :density, :int

    RecipeType.find_each do |r|
      r.density = r.density*100.round if !r.density.nil?
      r.save!
    end
    change_column :recipe_types, :density, :int

    ContainerReference.find_each do |c|
      c.mass = c.mass*100.round
      c.volume = c.volume*100.round
      c.save!
    end
    change_column :container_references, :mass, :int
    change_column :container_references, :volume, :int

    Container.find_each do |c|
      c.price = c.price*100.round
      c.quantity_actual = c.quantity_actual*100.round if !c.quantity_actual.nil?
      c.quantity_init = c.quantity_init*100.round
      c.save!
    end
    change_column :containers, :price, :int
    change_column :containers, :quantity_actual, :int
    change_column :containers, :quantity_init, :int

  end

end
