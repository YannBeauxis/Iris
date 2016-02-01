class AddDescription < ActiveRecord::Migration
  def change
    [:ingredient_types, :recipe_types, :ingredients, :recipes].each do |t|
      add_column t, :description, :string
    end
  end
end
