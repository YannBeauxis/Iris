class CustomMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  
  def new_user_alert(record, opts={})
    opts[:to] = 'mail@yannbeauxis.net'
    devise_mail(record, :new_user_alert, opts)
  end

  def contact_message(record, opts)
    opts[:to] = 'mail@yannbeauxis.net'
    opts[:subject] = '[IRIS] Message de contact'
    @message = opts
    devise_mail(record, :contact_message, opts)
  end

end