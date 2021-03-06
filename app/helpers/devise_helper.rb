module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    flash[:alert] = sentence

    #html = <<-HTML
    #<div id="error_explanation">
    #  <p>#{sentence}</p>
    #  <ul>#{messages}</ul>
    #</div>
    #HTML

    #html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

  def current_or_guest_user
    controller.current_or_guest_user
  end

  def current_user
    if super
      super
    else
    controller.current_or_guest_user
    end
  end

end