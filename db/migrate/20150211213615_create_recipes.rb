class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.references :recipe_type, index: true

      t.timestamps null: false
    end
    add_foreign_key :recipes, :recipe_types
  end
end
