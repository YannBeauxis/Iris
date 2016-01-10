App.Views.PGProductsTable = Backbone.View.extend({
  
    initialize: function() {
    
    this.listenTo(this.collection, 'add', this.addProduct);

  },

  addProduct: function(p) {
    var pView = new App.Views.PGProduct({
                    model: p,
                  });
    this.$el.append(pView.render().el);
  },

});