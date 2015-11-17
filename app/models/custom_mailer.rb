class CustomMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  
  def new_user_alert(record, opts={})
    opts[:to] = 'yann.beauxis@gmail.com'
    devise_mail(record, :new_user_alert, opts)
  end
  
end