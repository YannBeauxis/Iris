class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :variant, index: true
      t.string :name
      t.float :volume
      t.string :detail

      t.timestamps null: false
    end
    add_foreign_key :products, :variants
  end
end
