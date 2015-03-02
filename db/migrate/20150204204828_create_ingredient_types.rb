class CreateIngredientTypes < ActiveRecord::Migration
  def change
    create_table :ingredient_types do |t|
      t.string :name
      t.string :name_short
      t.string :mesure_unit

      t.timestamps null: false
    end
  end
end
