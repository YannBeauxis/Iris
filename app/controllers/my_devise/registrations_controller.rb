class MyDevise::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!

#  def new
#    flash[:info] = 'Registrations are not open.'
#    redirect_to root_path
#  end

#  def create
#    flash[:info] = 'Demande d\'autorisation envoyé à l\'administrateur.'
#    redirect_to root_path
#  end

end 
