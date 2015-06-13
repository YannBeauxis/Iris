class RecipeType < ActiveRecord::Base
  has_many :recipes, :dependent => :restrict_with_error
  has_and_belongs_to_many :ingredient_types
  validates :name, presence: true


  def nb_products
    nb=0
    self.recipes.each { |r| nb += r.products.count }
    return nb
  end

end
