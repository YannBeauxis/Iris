class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.references :ingredient, index: true
      t.float :volume_init
      t.float :volume_actual
      t.float :price

      t.timestamps null: false
    end
    add_foreign_key :containers, :ingredients
  end
end
