App.Models.Product = Backbone.Model.extend({
  
  initialize: function(options) {
    if (this.get('variant_id') != undefined) {
      this.variant = this.collection.variants.findWhere({id: this.get('variant_id')});
    }
  },

  updateUrl: function() {
    this.url = this.collection.url + '/' + this.get('id');
  },

  nameDisplay: function() {
    return this.get('container') + ' ' + 
      App.displayQuantity({quantity: this.get('volume'), unit: 'ml'});
  },

  productionDateDisplay: function() {
    var date = this.get('production_date');
    return (date == null) ? date : App.convertDate(date);
  }

});