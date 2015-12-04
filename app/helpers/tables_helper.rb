module TablesHelper

  def table_by_category(options = {})
    
  # table headers
    str = content_tag :thead do
      content_tag :tr do
        concat content_tag(:th).to_s.html_safe 
        if options.has_key?(:columns_header) then
          options[:columns_header].collect {|column| concat content_tag(:th,column)}.join().html_safe  
        end
      end
    end

  col_count = options.has_key?(:columns_header) ? options[:columns_header].count : 0

    cat_params = options[:category]
    item_params = options[:item]
    
  # categories
    cat_params[:collection].order(:name).each do |category|
      strval = row_content(category, cat_params, "category", col_count)
      str += content_tag(:tr, strval, class: "type")
    # lines for item in category
      colored = true
      item_params[:collection].where(cat_params[:name] => category).order(:name).each do |i|
        if colored then
          cl = "filled"
        else
          cl= "blank"
        end
        colored = !colored
        strval = row_content(i, item_params, "item", col_count)
        str += content_tag(:tr, strval, class: cl)
      end
    end
    
  # return content table
    content_tag :table, str, class: "table"
    
  end

  def row_content(row, params, css_class, col_count)
    
  # first column : name with link
    if params.has_key?(:link_param) then
      path = url_for([params[:link_param],row])
    else
      path = url_for(row)
    end
    str_row = content_tag(:td, 
      link_to(row.name, path), 
      class: css_class)
    
  # other columns content
    if params.has_key?(:columns) then
      params[:columns].each do |column|
        if column.has_key?(:instance) then
          instance = column[:instance]
        else
          instance = row
        end
        if column.has_key?(:method) then
          if column.has_key?(:method_params) then
            method_params = column[:method_params]
            if column[:method_params] == "row" then
              method_params = row
            elsif method_params.kind_of?(Array)
              method_params = column[:method_params].collect { |p| if (p == "row"); row else p; end; }
            end
            display = instance.send(column[:method], *method_params)
          else 
            display = instance.send(column[:method])
          end
        else
          display = nil
        end
        str_row += content_tag(:td, display, class: 'value')          
      end
    else
      col_count.times do
        str_row += content_tag(:td, nil, class: 'value')   
      end   
    end  
    return str_row
  end

end