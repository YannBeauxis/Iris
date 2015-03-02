class Proportion < ActiveRecord::Base
  belongs_to :variant
  belongs_to :composant, polymorphic: true
  validates :value, :composant, presence: true
end
