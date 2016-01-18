App.Views.CategoryGrid = Backbone.View.extend({
  
  initialize: function(options) {
    
    App.currentGrid = this;
    
    this.options = options;
    this.options['mainView'] = this;

    this.$el = $(this.options.mainEl),
    
    // Hide the element before it's completely load
    this.$el.hide();
    
    App.sortByName = function(elTarget) {
      elTarget.append(
          elTarget.children().sort(function (a,b) {
          aName = $(a).attr('name');
          bName = $(b).attr('name');
          return (aName < bName) ? -1 : (bName < aName) ? 1 : 0;
        })
      );
      return elTarget;
    };
    
    // For listenTo filter on some views
    App.contextMenuView = 
      new this.options.contextMenu({el: $('#ContextMenu'),options: this.options});
    
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
   
    
    if (App.categoryFitler != null) {
      //categoryParams = {data: {}};
      var categoryParams = {};
      categoryParams[App.categoryFitler.param] =
        $(App.categoryFitler.selector).val();
     categoryParams = $.param(categoryParams);
    }
    
    var self = App.currentGrid;
    self.$el.hide().children().remove();
    self.categories.reset();
    self.items.reset();
    self.categories.fetch({
      data: categoryParams, 
      success: function() {
        self.items.fetch({success: function() {
          self.items.trigger('sortByName');
          self.sortByName(self.$el).show();
        }});
    }});
  },
  
  addOneCategory: function(category) {
    var view = new App.Views.Category({
                      model: category, 
                      options: this.options});
    var it = this.$el.append(view.render().el);
    it.find('.default-hidden').hide();
  },
  
  sortByName: function() {
    this.$el.append(
        this.$el.children().sort(function (a,b) {
        aName = $(a).attr('name');
        bName = $(b).attr('name');
        return (aName < bName) ? -1 : (bName < aName) ? 1 : 0;
      })
    );
    return this.$el;
  }
  
});