App.Views.PGQuantitiesTable = Backbone.View.extend({
  
    initialize: function(options) {
    
    this.options = options.options;
    this.listenTo(this.collection, 'add', this.addIngredientType);

  },

  addIngredientType: function(it) {
    var itView = new App.Views.PGIngredientType({
                    model: it,
                    collection: this.options.ingredients,
                    options: this.options
                  });
    this.$el.append(itView.render().el);
  },

});