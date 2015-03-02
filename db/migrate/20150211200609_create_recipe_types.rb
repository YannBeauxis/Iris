class CreateRecipeTypes < ActiveRecord::Migration
  def change
    create_table :recipe_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
