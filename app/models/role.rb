class Role < ActiveRecord::Base
  has_many :users
  validates :name, :rank, presence: true
end
