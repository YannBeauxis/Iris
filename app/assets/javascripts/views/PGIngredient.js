App.Views.PGIngredient = Backbone.View.extend({
  
  tagName: 'tr',
  
  template: JST['pg_ingredient'],
  
  initialize: function(options) {

    this.options = options.options;
    this.$el.attr({sort_key: this.options.ingredientType.get('name') + '_' + this.model.get('name')});
    
    this.model.set('okToChangeType',false);
    
    this.listenTo(this.collection, 'reset', this.removeView);   
    this.listenTo(this.model, 'remove', this.remove);   
    this.listenTo(this.options.appView, 'compute', this.compute);
    
  },

  compute: function(options) {
      this.$el.find('td.quantity-type-proportion').text(Math.round(this.model.get('proportion')*10000)/100 + ' %');
      
      //volume
      this.model.set('computed-volume', this.model.get('volume')*this.options.appView.volume);
      this.$el.find('td.quantity-type-volume').text(
        App.displayQuantity({
          quantity: this.model.get('computed-volume')*100, 
          unit: 'ml'
        })
      );

      //mass
      this.model.set('computed-mass', this.model.get('mass')*this.options.appView.volume);
      this.$el.find('td.quantity-type-mass').text(
        App.displayQuantity({
          quantity: this.model.get('computed-mass')*100, 
          unit: 'g'
        })
      );

      //cost
      if (this.model.get('cost') != null) {
        this.model.set('computed-cost', this.model.get('cost')*this.options.appView.volume);
        this.$el.find('td.quantity-type-cost').text(
        App.displayQuantity({
          quantity: this.model.get('computed-cost')*100, 
          unit: '€'
        })
      );
      } else {
        this.model.set('computed-cost', null);
        this.$el.find('td.quantity-type-cost').text('');
      }
 

      //quantity
      var quantity = this.model.get('quantity')*this.options.appView.volume;
      if (quantity > 0 && quantity < 100) {
        this.$el.find('td.quantity-type-quantity').text(
          Math.round(quantity) + ' gt.');
      } else {
        this.$el.find('td.quantity-type-quantity').empty();
      }
      this.$el.show();
    //}

    //to compute quantities of ingredient types
    this.model.set('okToChangeType',true);
    this.trigger('okToChangeType');
  },
  
  removeView: function(){
    this.remove();
  },
  
  render: function () {
    this.$el.html(this.template(this.model));
    return this;
  }

});