class RegistrationsController < Devise::RegistrationsController

  def new
    @user = User.new
    @roles = Role.where("rank >= 3")
    sub_text = {3 => 'création de recettes', 4 => 'consultation uniquement'}
    @roles.each { |r| r.name += ' (' + sub_text[r.rank] + ')' }
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :role_id, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name,:role_id, :email, :password, :password_confirmation, :current_password)
  end
  
end