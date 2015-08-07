module TablesHelper

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
          strval += content_tag(:td, i.send(column[:value]), class: 'center')
        end
        
        str += content_tag :tr, strval, class: cl
      end

    end
    
    content_tag :table, str, class: "colored"
  end

end