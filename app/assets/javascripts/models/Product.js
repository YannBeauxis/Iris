App.Models.Product = Backbone.Model.extend({
  
  initialize: function() {this.url = this.collection.url;},

  productionDateDisplay: function() {
    var date = this.get('production_date');
    return (date == null) ? date : date.slice(0,10);
  }

});