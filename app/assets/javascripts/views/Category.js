App.Views.Category = Backbone.View.extend({
  
  tagName: 'div',
  
  //id: function(){
  //  return 'ingredient-type-' + this.model.get('id');
  //},
  
  attributes: function(){
      return {name: this.model.get('name')};
    },
  
  className: function(){
    this.closedClass = 'col-xs-12 col-sm-6 col-md-4 closed';
    this.openClass = 'col-xs-12 open';
    return 'category ' + this.closedClass;
    },

  initialize: function(options) {
    
    this.options = options.options;
    
    this.template = JST[this.options.templates['category']];
    
    this.collection = new this.options.item.collection();
    this.listenTo(this.options.mainView.items, 'add', this.addItem);

    this.itemsTableView = 
      new App.Views.CategoryItemsTable({
        model: this.model, 
        collection: this.collection,
        options: this.options
      });
      
    this.badgeView = 
      new App.Views.CategoryBadge({model: this.model, collection: this.collection});

    this.listenTo(this.options['mainView'].items, 'sortByName', this.sortByName);

  },

  events: {
    "click .panel-heading":  "displayItems",
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
      var view = new App.Views.Item({
        model: item, 
        options: this.options
      });
      this.$el.find('.items-table').find('tbody').append(view.render().el);
    }
  },

  removeItem: function(item) {
    this.collection.remove(item);
  },

  render: function() {
    
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.find('.default-hidden').append(this.itemsTableView.render().el);
      this.$el.find('.panel-heading').prepend(this.badgeView.render().el);
      
      return this;
  },
  
  sortByName: function() {
    App.sortByName(this.itemsTableView.$el.find('tbody'));
  },
  
  displayItems: function() {
    this.$el.toggleClass(this.closedClass);
    this.$el.toggleClass(this.openClass);
    var p = this.$el.position().top;
    $('html, body').animate({
      scrollTop:this.$el.offset().top
      }, 'slow');
    this.$el.find('.default-hidden')
      .slideToggle();

  },
  
  scrollAnim: function(p){
    console.log(p);
    $(window).scrollTop(p - 5);
  }
  
});