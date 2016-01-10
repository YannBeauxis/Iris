App.Collections.Products = Backbone.Collection.extend({
  
  model: App.Models.Product,
  
  initialize: function(options) {
    this.url = options.url;
  }
  
});