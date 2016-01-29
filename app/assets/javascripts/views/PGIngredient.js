App.Views.PGIngredient = Backbone.View.extend({
  
  tagName: 'tr',
  
  template: JST['pg_ingredient'],
  
  initialize: function(options) {
    
    this.model.set('okToChangeType',false);
    this.options = options.options;
    
    this.listenTo(this.collection, 'reset', this.removeView);   
    this.listenTo(this.model, 'remove', this.remove);   
    this.listenTo(this.options.appView, 'compute', this.compute);
    
  },

  compute: function(options) {
      this.$el.find('td.proportion').text(Math.round(this.model.get('proportion')*10000)/100 + ' %');
      
      //volume
      this.model.set('volume', this.model.get('volume')*this.options.appView.volume);
      this.$el.find('td.volume').text(
        Math.round(this.model.get('volume')*100)/100 + ' ml');
      
      //mass
      this.model.set('mass', this.model.get('mass')*this.options.appView.volume);
      this.$el.find('td.mass').text(
        Math.round(this.model.get('mass')*100)/100 + ' g');
  
      //quantity
      var quantity = this.model.get('quantity')*this.options.appView.volume;
      if (quantity > 0 && quantity < 100) {
        this.$el.find('td.quantity').text(
          Math.round(quantity) + ' gt.');
      } else {
        this.$el.find('td.quantity').empty();
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
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }

});