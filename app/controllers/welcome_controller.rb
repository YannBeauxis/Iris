class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_load_and_authorize_resource
  skip_authorization_check

end
