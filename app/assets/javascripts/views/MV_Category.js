App.Views.MV_Category = Backbone.View.extend({

  className: ['main-view__collection'],
  
  initialize: function(options) {
    
    this.options = options.options;
    
    this.template = JST[this.options.templates['category']];
    
    this.collection = new this.options.item.collection();
    this.listenTo(this.options.mainView.items, 'add', this.addItem);
    
    this.badgeView = 
      new App.Views.CategoryBadge({
        model: this.model, 
        collection: this.collection,
        options: this.options
      });
  },

  events: {
    
  },

  addItem: function(item) {

    if (item.category_id == this.model.get('id'))
      {
        this.showItem(item);
        this.listenTo(item, 'hide', this.removeItem);
        this.listenTo(item, 'show', this.showItem);
      }
  },

  showItem: function(item) {

    if (!this.collection.findWhere({id: item.id})) {
      this.collection.add(item);
      var view = new App.Views.MV_Item({
        model: item, 
        options: this.options
      });
      this.$el.find('.scrolls').append(view.render().el);
      this.changeSelect();
      if (this.options.badgeOnSelected) {
        this.listenTo(view, 'changeSelect', this.changeSelect);
      }
    }
  },

  changeSelect: function() {
  // Badge is number of selected items, change the badge value
    this.badgeView.numberSelected = this.$el.find('input:checked').length;
    this.badgeView.render();
    return this;
  },

  removeItem: function(item) {
    this.collection.remove(item);
  },

  render: function() {
    
      this.$el.html(this.template(this.model.toJSON()));
      
      return this;
  },

});