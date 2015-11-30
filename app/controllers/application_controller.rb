class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  
  before_filter :authenticate_user!

  check_authorization :unless => :devise_controller?

  load_and_authorize_resource :unless => :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, :alert => exception.message
  end
  
end
