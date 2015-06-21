class User < ActiveRecord::Base
  has_many :recipes, dependent: :destroy
  has_many :containers, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
          :registerable,
          #:recoverable, 
         :rememberable, :trackable, :validatable

  
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
  
end
