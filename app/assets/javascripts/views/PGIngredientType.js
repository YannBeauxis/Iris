App.Views.PGIngredientType = Backbone.View.extend({
  
  tagName: 'tr',
  
  className: 'category',
  
  template: JST['pg_ingredient_type'],
  
  initialize: function(options) {
    
    this.options = options.options;

    this.ingredients = new App.Collections.Ingredients(); 

    this.listenTo(this.collection, 'reset', this.removeView);    
    this.listenTo(this.ingredients, 'add', this.addIngredient);
    this.listenTo(this.options.appView, 'compute', this.computeProp);
    
  },

  addIngredient: function(i) {
    var iView = new App.Views.PGIngredient({
                    model: i,
                    collection: this.ingredients,
                    options: this.options
                  });
    this.$el.after(iView.render().el);
    this.listenTo(iView, 'okToChangeType', this.computeValues);
  },

  computeProp: function(options) {
    this.$el.find('td.quantity-type-proportion').text(Math.round(this.model.get('proportion')*10000)/100 + ' %');
  },

  computeValues: function(options) {
    var type_id = this.model.id;
    var test = (this.collection.where({
                  okToChangeType: false,
                  ingredient_type_id: type_id
                }).length == 0 );
    if (test) {
      
      volume = 0;
      mass = 0;
     //reset okToCangeType
      this.ingredients.forEach(function(ingredient, index) {
        if (ingredient.get('computed-volume')>0) {volume += ingredient.get('computed-volume');}
        if (ingredient.get('computed-mass')>0) {mass += ingredient.get('computed-mass');}
        ingredient.set('okToChangeType', false);
      });
      
      this.$el.find('td.quantity-type-volume').text(
        Math.round(volume*100)/100 + ' ml');
        
      this.$el.find('td.quantity-type-mass').text(
        Math.round(mass*100)/100 + ' g');    
    }
  },

  removeView: function(){
    this.ingredients.reset();
    this.remove();
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }

});