class AddRankToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :rank, :integer
    Role.find_each do |r|
      if r.name == 'admin'
        r.rank = 1
      elsif r.name == 'gerant'
        r.rank = 2    
      elsif r.name == 'producteur'
        r.rank = 3  
      else
        r.rank = 4    
      end
      r.save
    end
  end
  
end
