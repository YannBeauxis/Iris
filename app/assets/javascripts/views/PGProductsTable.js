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

  render: function() {
    this.$el.toggle(this.collection.length>0);
  }

});