class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  
  #force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development? && !Rails.env.test?
  end

  #before_filter :authenticate_user!

  check_authorization :unless => :devise_controller?

  load_and_authorize_resource :unless => :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      redirect_to :back, :alert => exception.message
    else
      authenticate_user!
    end
  end

#https://github.com/plataformatec/devise/wiki/How-To:-Create-a-guest-user
  protect_from_forgery

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).reload.try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
  end

  def create_guest_user
    guest_email = "guest@projet-iris.com"
    u = User.find_by(email: guest_email)
    if u.nil?
      u = User.create(:name => "guest", :email => guest_email)
    end
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
    #User.new
  end
  
end
