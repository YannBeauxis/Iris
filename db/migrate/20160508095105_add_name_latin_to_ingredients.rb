class AddNameLatinToIngredients < ActiveRecord::Migration
  def change 
    change_table :ingredients do |t|
      t.string :name_latin
      t.boolean :validated, default: false
      t.references :user, index: true, foreign_key: true
    end
    Ingredient.find_each do |i|
      i.user = User.find_by(email: 'yann.beauxis@gmail.com')
      i.validated = true
      i.save!
    end
  end
end
