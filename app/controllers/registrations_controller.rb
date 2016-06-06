class RegistrationsController < Devise::RegistrationsController

  def new
    init_roles
    super
  end
  
  def create
    init_roles
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :role_id, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name,:role_id, :email, :password, :password_confirmation, :current_password)
  end
  
  def init_roles
    @roles = Role.where("rank >= 3")
    sub_text = {3 => 'création de recettes', 4 => 'consultation uniquement'}
    @roles.each { |r| r.name += ' (' + sub_text[r.rank] + ')' }
  end
  
end