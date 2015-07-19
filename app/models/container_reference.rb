class ContainerReference < ActiveRecord::Base
  belongs_to :ingredient_type
  validates :ingredient_type, :volume, :mass, presence: :true
end
