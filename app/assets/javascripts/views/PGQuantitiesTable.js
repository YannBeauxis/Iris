App.Views.PGQuantitiesTable = Backbone.View.extend({
  
    initialize: function(options) {
    
    this.options = options.options;
    this.ingredientTypes = new App.Collections.IngredientTypes(); 
    this.quantitySelectors = new App.Collections.PGQuantitySelectors();
    
    this.listenTo(this.ingredientTypes, 'add', this.addIngredientType);
    this.listenTo(this.quantitySelectors, 'add', this.addQuantitySelector);

  },

  addIngredientType: function(it) {
    var itView = new App.Views.PGIngredientType({
                    model: it,
                    collection: this.ingredientTypes,
                    options: this.options
                  });
    this.$el.append(itView.render().el);
    itView.ingredients.add(it.get('ingredients'));
    this.listenTo(itView, 'okToChangeTotal', this.computeValues);
  },

  computeValues: function(options) {
    var test = (this.ingredientTypes.where({
                  okToChangeTotal: false
                }).length == 0 );
    if (test) {
      
      cost = 0;
     //reset okToChangeTotal
      this.ingredientTypes.forEach(function(ingredientType, index) {
        if (ingredientType.get('computed-cost') != null && cost != null) {cost += ingredientType.get('computed-cost');
        } else {
          cost = null;
        }
        ingredientType.set('okToChangeTotal', false);
      });
      
      //to display cost
      this.trigger('changeCost', cost);
    }
  },

  addQuantitySelector: function(qs) {
    var qsView = new App.Views.PGQuantitySelector({
                    model: qs,
                    attributes: {selector: qs.get('quantityType')}
                  });
    this.$el.find('#quantity-selectors').append(qsView.render().el);
    this.displayQuantityType({quantityType: qs.get('quantityType'), display: qs.get('selected')});
    this.listenTo(qsView, 'selectorClick', this.displayQuantityType);
  },
  
  updateAllDisplayQuantityType: function() {
    var self = this;
    this.quantitySelectors.each(
      function (selector, index) {
        self.displayQuantityType({
          quantityType: selector.get('quantityType'),
          display: selector.get('selected')
        });
    });
  },
  
  displayQuantityType: function(options) {
  // options : {quantityType: string, display: boolean}
    this.$el.find('.quantity-type-' + options.quantityType).toggle(options.display);
  }

});