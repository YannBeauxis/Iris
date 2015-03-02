class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :name
      t.references :recipe, index: true

      t.timestamps null: false
    end

    add_foreign_key :variants, :recipes
  end
end
