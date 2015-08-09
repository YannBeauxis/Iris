class Proportion < ActiveRecord::Base
  belongs_to :variant
  belongs_to :composant, polymorphic: true
  validates :composant, presence: true
  #validates_numericality_of :value, :greater_than_or_equal_to => 0
end
