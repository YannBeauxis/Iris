module MenusHelper
  #attr_accessor :menu, :controller, :action, :label, :id
  
  def add_menu_item(options = {})
    if options.has_key?(:path) then
      path = options[:path]
    else
      path = url_for(controller: options[:controller], action: options[:action])      
    end
    content_for options[:menu] do
      content_tag(:span, link_to(options[:label], path, options[:link_param]), class: "menu-link")
    end
  end
end