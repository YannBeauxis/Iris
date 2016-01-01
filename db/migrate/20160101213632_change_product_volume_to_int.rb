class ChangeProductVolumeToInt < ActiveRecord::Migration
  def change
    Product.find_each do |p|
      p.volume = p.volume*100.round
      p.save!
    end
    change_column :products, :volume, :int
  end
end
