module MenusHelper
  #attr_accessor :menu, :controller, :action, :label, :id
  
  def menu_item(options = {})

    if options.has_key?(:can_condition) then
      conditions = options[:can_condition]
      show = can?(conditions[:action], conditions[:object])
    else
      show = true
    end
    
    #if options.has_key?(:path) then
      path = options[:path]
    #else
    #  path = url_for(controller: options[:controller], action: options[:action])      
    #end
    if show then
      content_for options[:menu] do
        content_tag(:span, link_to(options[:label], path, options[:link_param]), class: "menu-link")
      end
    end
  end
end