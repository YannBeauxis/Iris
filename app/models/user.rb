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
  validates :name, presence: true

  after_initialize :get_warehouse
  after_create :send_new_user_alert
  
  def send_new_user_alert
    CustomMailer.new_user_alert(self).deliver_now
  end
  #def approved?
  #  super or (self.role == Role.find_by_name('client'))
  #end

  def role
    if self.approved? then
      r = super
    else
      r = Role.find_by_name('client')
    end
    return r
  end

  def get_warehouse
    @warehouse = Warehouse.new('user',{user: self})
  end

  def warehouse
    @warehouse
  end

  #def active_for_authentication? 
  #  super && approved? 
  #end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
  
  def admin?
    self.role.name == 'admin'
  end

  private
  def set_default_info
    self.role ||= Role.find_by_name('client')
  end
end
