class AddColumnsToProduct < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.rename :detail, :description
      t.rename :name, :container
      t.column :number_produced, :integer
      t.column :production_date, :datetime
      t.column :expiration_date, :datetime
    end
  end
end
