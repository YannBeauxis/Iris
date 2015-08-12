module TablesHelper

  def table_by_category(options = {})
    
    str = content_tag :thead do
      content_tag :tr do
        concat content_tag(:th).to_s.html_safe 
        options[:columns].collect {|column|  concat content_tag(:th,column[:name])}.join().html_safe   
      end
    end

    cat_params = options[:category]
    item_params = options[:item]
    
    cat_params[:collection].each do |category|

      # line for type
      str += content_tag :tr do
        if cat_params.has_key?(:link_param) then
          path = url_for([cat_params[:link_param],category])
        else
          path = url_for(category)
        end
        concat content_tag(:td, 
          link_to(category.name, path), 
          class: "type"
        ).to_s.html_safe
      end
      
      # lines for item in type
      colored = true
      item_params[:collection].where(cat_params[:name] => category).sort_by {|i| i.name }.each do |i|
        if colored then
          cl = "filled"
        else
          cl= "blank"
        end
        colored = !colored
        
        #title with link
        if item_params.has_key?(:link_param) then
          path = url_for([item_params[:link_param],i])
        else
          path = url_for(i)
        end
        strval = content_tag(:td, 
            link_to(i.name, path), 
            class: "item"
          )
        #column values
        options[:columns].each do |column|
          if column.has_key?(:method) then
            if column.has_key?(:method_params) then
              display = i.send(column[:method], column[:method_params])
            else 
              display = i.send(column[:method])
            end
          elsif column.has_key?(:value)
            display = column[:value]
          else
            display = nil
          end
          strval += content_tag(:td, display, class: 'center')
        end
        
        str += content_tag :tr, strval, class: cl
      end

    end
    
    content_tag :table, str, class: "colored"
  end

  def table_by_type(options = {})
    
    str = content_tag :thead do
      content_tag :tr do
        concat content_tag(:th).to_s.html_safe 
        options[:columns].collect {|column|  concat content_tag(:th,column[:name])}.join().html_safe   
      end
    end

    options[:types].each do |type|

      # line for type
      str += content_tag :tr do
        concat content_tag(:td, 
          link_to(type.name, type), 
          class: "type"
        ).to_s.html_safe
      end
      
      # lines for item in type
      colored = true
      options[:items].where(type: type).sort_by {|i| i.name }.each do |i|
        if colored then
          cl = "filled"
        else
          cl= "blank"
        end
        colored = !colored
        
        #title with link
        strval = content_tag(:td, 
            link_to(i.name, url_for(i)), 
            class: "item"
          )
        #column values
        options[:columns].each do |column|
          if column.has_key?(:method) then
            display = i.send(column[:method])
          elsif column.has_key?(:value)
            display = column[:value]
          else
            display = nil
          end
          strval += content_tag(:td, display, class: 'center')
        end
        
        str += content_tag :tr, strval, class: cl
      end

    end
    
    content_tag :table, str, class: "colored"
  end

end