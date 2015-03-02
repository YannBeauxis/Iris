class CreateProportions < ActiveRecord::Migration
  def change
    create_table :proportions do |t|
      t.references :variant, index: true
      t.references :composant, polymorphic: true, index: true
      t.float :value

      t.timestamps null: false
    end
    add_foreign_key :proportions, :variants
    #add_foreign_key :proportions, :composants
  end
end
