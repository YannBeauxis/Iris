class CategoryTable
  include Rails.application.routes.url_helpers
  #default_url_options[:host]
  
  def initialize(options = {})
    get_data(options)
  end

  def get_data(options = {})
    @table = {}
    @content = []
    
    if options.has_key?(:columns_header) then
      @table[:header] = options[:columns_header]
    end
    
    cat_params = options[:category]
    item_params = options[:item]
    
      tb_cat = cat_params[:collection].order(:name).each do |category|
        li = []
        
        item_params[:collection].where(cat_params[:name] => category).order(:name).each do |i|
          content = row_content(i, item_params)
          li << {name: i.name, 
                  url: polymorphic_url(i, :routing_type => :path), 
                  content: content}
        end
        
        url = polymorphic_url(category, :routing_type => :path)
        @content  << {name: category.name, url: url, items: li}
      end
      
      @table[:content] = @content
      
  end

  def display_table
    @table.as_json
  end

  def row_content(row, params)
    result = []
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
            result << instance.send(column[:method], *method_params)
          else 
            result << instance.send(column[:method])
          end
        end        
      end
    end  
    result
  end

end