class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.references :ingredient_type, index: true

      t.timestamps null: false
    end
    add_foreign_key :ingredients, :ingredient_types
  end
end
