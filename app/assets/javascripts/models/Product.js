App.Models.Product = Backbone.Model.extend({
  
  initialize: function() {
    this.url = this.collection.url + '/' + this.id;
  },

  productionDateDisplay: function() {
    var date = this.get('production_date');
    return (date == null) ? date : App.convertDate(date);
  }

});