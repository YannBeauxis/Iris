App.Views.MV_Main = Backbone.View.extend({
  
  initialize: function(options) {
    
    App.currentGrid = this;
    
    this.options = options;
    this.options['mainView'] = this;

    this.$el = $(this.options.mainEl),
    
    // Hide the element before it's completely load
    this.$el.hide();
    
    this.categories = new this.options.category.collection();
    this.items = new this.options.item.collection();
    
    this.listenTo(this.options.mainView.categories, 'add', this.addOneCategory);
    //this.listenTo(this.options.mainView.items, 'add', this.addOneItem);    
   
    this.loadData();
   
   
  },
  
    events: {
    "change #recipe_recipe_type_id":  "this.loadData"
  },

  
  loadData : function() {
   
    var categoryParams = {}; 
    if (App.categoryFilter != null) {
      categoryParams[App.categoryFilter.param] =
        $(App.categoryFilter.selector).val();
    }
    if (App.variantId != null) {
      categoryParams['variant_id'] = App.variantId;
    }
    categoryParams = $.param(categoryParams);
    var self = App.currentGrid;
    self.$el.hide().children().remove();
    self.categories.reset();
    //self.items.reset();
    self.categories.fetch({
      data: categoryParams, 
      success: function() {
        self.items.fetch({
          data: categoryParams, 
          success: function() {
            self.items.trigger('sortByName');
            App.sortByName(self.$el).show();
          }});
    }});
  },
  
  addOneCategory: function(category) {
    var view = new App.Views.MV_Category({
                      model: category, 
                      options: this.options});
    var it = this.$el.append(view.render().el);
    it.find('.default-hidden').hide();
  }
  
});