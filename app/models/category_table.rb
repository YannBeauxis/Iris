class CategoryTable
  include Rails.application.routes.url_helpers
  #default_url_options[:host]
  
  def initialize(options = {})
    get_data(options)
  end

  def get_data(options = {})
    
    cat_params = options[:categories]
    #item_params = options[:items]
    columns_params = options[:columns]

    @table = {}
    header = []
    content = []
    id=0

    @table[:header] = columns_params.collect do |cp|
      {id: (cp.has_key?(:id) ? cp[:id] : id +=1 ),
       header: (cp.has_key?(:header) ? cp[:header] : nil)}
    end

    cat_params[:collection].order(:name).each do |cat|
      cat_col = []
      
      columns_params.each do |cp_cat|
        cat_col << (cp_cat.has_key?(:category) ? row_content(cat, cp_cat[:category]) : nil)
      end
      
      li = []
      
      options[:items].where(cat_params[:name] => cat).order(:name).each do |it|
        it_col = []
        columns_params.each do |cp_it|
          it_col << (cp_it.has_key?(:item) ? row_content(it, cp_it[:item]) : nil)
        end
        li << {name: it.name, 
                url: polymorphic_url(it, :routing_type => :path), 
                columns: it_col}
      end
      
      url = polymorphic_url(cat, :routing_type => :path)
      
      #category collected to @table
      content << {name: cat.name, url: url, columns: cat_col, items: li}
    end
    
    @table[:content] = content
      
  end

  def display_table
    @table.as_json
  end

  def row_content(row, option)
  # this method send method option[:method] with option[:params] if exist 
  #to row or other instance specified by :instance option
    
    result = nil
    instance = option.has_key?(:instance) ? option[:instance] : row
    
    if option.has_key?(:method) then
      method = option[:method]
      if option.has_key?(:params) then
        method_params = option[:params]
        if option[:params] == "row" then
          method_params = row
        elsif method_params.kind_of?(Array)
          method_params = option[:method_params].collect { |p| if (p == "row"); row else p; end; }
        end
        result = instance.send(option[:method], *method_params)
      else 
        result = instance.send(option[:method])
      end
    end    
    result  
  end

end