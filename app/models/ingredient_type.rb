class IngredientType < ActiveRecord::Base
  has_many :ingredients, dependent: :destroy
  has_and_belongs_to_many :recipe_types
  has_many :proportions, as: :composant
  validates :name,:name_short, presence: true
  validates :mesure_unit , inclusion: { in: %w(ml g),
    message: "%{value} is not a valid volmue unit" }, allow_nil: false
end
