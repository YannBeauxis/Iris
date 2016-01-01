class ChangeProportionValueToInt < ActiveRecord::Migration
  def change
    #Proportion.find_each do |p|
    #  p.value = p.value*10000.round
    #  p.save!
    #end
    change_column :proportions, :value, :int
  end
end
