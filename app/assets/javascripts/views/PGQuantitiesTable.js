App.Views.PGQuantitiesTable = Backbone.View.extend({
  
    initialize: function(options) {
    
    this.options = options.options;
    this.ingredientTypes = new App.Collections.IngredientTypes(); 
    this.listenTo(this.ingredientTypes, 'reset', this.removeIngredientTypes);
    this.listenTo(this.ingredientTypes, 'add', this.addIngredientType);

  },

  addIngredientType: function(it) {
    var itView = new App.Views.PGIngredientType({
                    model: it,
                    collection: this.ingredientTypes,
                    options: this.options
                  });
    this.$el.append(itView.render().el);
    itView.ingredients.add(it.get('ingredients'));
  },

  removeIngredientTypes: function() {
    
  }

});