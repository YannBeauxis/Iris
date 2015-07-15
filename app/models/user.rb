class User < ActiveRecord::Base
  belongs_to :role
  has_many :recipes, dependent: :destroy
  has_many :containers, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
          :registerable,
          :recoverable, 
         :rememberable, :trackable, :validatable
  before_create :set_default_info
  #validates :name, presence: true
  
  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
  
  def is_admin?
    self.role.name == 'admin'
  end
  
  private
  def set_default_info
    self.role ||= Role.find_by_name('client')
  end
end
