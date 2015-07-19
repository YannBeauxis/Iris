class CreateContainerReferences < ActiveRecord::Migration
  def change
    create_table :container_references do |t|
      t.references :ingredient_type, index: true
      t.float :volume
      t.float :mass

      t.timestamps null: false
    end
    add_foreign_key :container_references, :ingredient_types
  end
end
