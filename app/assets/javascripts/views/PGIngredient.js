App.Views.PGIngredient = Backbone.View.extend({
  
  tagName: 'tr',
  
  template: JST['pg_ingredient'],
  
  initialize: function(options) {
    
    this.model.set('okToChangeType',false);
    this.options = options.options;
    
    this.listenTo(this.collection, 'add', this.addIngredient);
    this.listenTo(this.options.appView, 'compute', this.compute);
    
  },

  addIngredient: function(i) {
    
  },

  compute: function(options) {
    var values = this.options.appView.variants
        .findWhere({
          id: parseInt(options.variant_id)
        }).toJSON().ingredients[this.model.id];
    //proportion
    this.$el.find('td.proportion').text(Math.round(values.proportion*10000)/100 + ' %');
    
    //volume
    this.model.set('volume', values.volume*this.options.appView.volume);
    this.$el.find('td.volume').text(
      Math.round(this.model.get('volume')*100)/100 + ' ml');
    
    //mass
    this.model.set('mass', values.mass*this.options.appView.volume);
    this.$el.find('td.mass').text(
      Math.round(this.model.get('mass')*100)/100 + ' g');

    //quantity
    var quantity = values.quantity*this.options.appView.volume;
    if (quantity > 0 && quantity < 100) {
      this.$el.find('td.quantity').text(
        Math.round(quantity) + ' gt.');
    } else {
      this.$el.find('td.quantity').empty();
    }


    //to compute quantities of ingredient types
    this.model.set('okToChangeType',true);
    this.trigger('okToChangeType');
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }

});