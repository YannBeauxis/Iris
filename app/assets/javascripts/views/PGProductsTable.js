App.Views.PGProductsTable = Backbone.View.extend({
  
    initialize: function() {
    
    this.listenTo(this.collection, 'add', this.addProduct);
    this.listenTo(this.collection, 'remove', this.render);
    
  },

  addProduct: function(p) {
    var pView = new App.Views.PGProduct({
                    model: p,
                  });
    this.$el.find('tbody.products').append(pView.render().el);
    this.render();
    this.listenTo(pView, 'displayProduct', this.displayProduct);
  },

  displayProduct: function(model) {
    this.trigger('displayProduct',model);
  },

  sortRows: function() {
    App.sortBy({
      elTarget: this.$el.find('tbody'),
      sort_key: 'sort_key',
      order: -1
    });
    return this.$el;
  },

  render: function() {
    this.sortRows().toggle(this.collection.length>0);
    return this;
  }

});