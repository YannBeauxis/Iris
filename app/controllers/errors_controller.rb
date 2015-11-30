class ErrorsController < ApplicationController
skip_before_filter :authenticate_user!
skip_authorization_check
skip_load_and_authorize_resource

  def not_found
    render :status => 404
  end

  def internal_server_error
    render :status => 500
  end
end
