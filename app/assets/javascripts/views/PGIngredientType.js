App.Views.PGIngredientType = Backbone.View.extend({
  
  tagName: 'tr',
  
  className: 'category',
  
  template: JST['pg_ingredient_type'],
  
  initialize: function(options) {
    
    this.options = options.options;
    
    this.listenTo(this.collection, 'add', this.addIngredient);
    this.listenTo(this.options.appView, 'compute', this.computeProp);
    
  },

  addIngredient: function(i) {
    if (i.get('ingredient_type_id') == this.model.id) {
      var iView = new App.Views.PGIngredient({
                      model: i,
                      collection: this.collection,
                      options: this.options
                    });
      this.$el.after(iView.render().el);
      this.listenTo(iView, 'okToChangeType', this.computeValues);
    }
  },

  computeProp: function(options) {
    var values = this.options.appView.variants
        .findWhere({
          id: parseInt(options.variant_id)
        }).toJSON().ingredientTypes[this.model.id];
    this.$el.find('td.proportion').text(Math.round(values.proportion*10000)/100 + ' %');
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
      this.collection.forEach(function(ingredient, index) {
        if (ingredient.get('ingredient_type_id') == type_id) {
          if (ingredient.get('volume')>0) {volume += ingredient.get('volume');}
          if (ingredient.get('mass')>0) {mass += ingredient.get('mass');}
          ingredient.set('okToChangeType', false);
        }
      });
      
      this.$el.find('td.volume').text(
        Math.round(volume*100)/100 + ' ml');
        
      this.$el.find('td.mass').text(
        Math.round(mass*100)/100 + ' g');    
    }
  this.stripRows();
  },

  stripRows: function(){
    // color one line each 2 of displayed lines
    var el = this.$el.next();
    var filled = false;
    while(!el.hasClass('category') && el.length > 0) {
      if (el.is(':visible')) {
        el.toggleClass('filled', filled);
        filled = !filled;
      }
      el = el.next();
    }
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }

});