App.Models.Product = Backbone.Model.extend({
  
  initialize: function() {
    //this.updateUrl();
  },

  updateUrl: function() {
    this.url = this.collection.url + '/' + this.get('id');
    //console.log(this.url);
  },

  productionDateDisplay: function() {
    var date = this.get('production_date');
    return (date == null) ? date : App.convertDate(date);
  }

});