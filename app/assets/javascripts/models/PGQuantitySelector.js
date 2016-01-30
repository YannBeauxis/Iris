App.Models.PGQuantitySelector = Backbone.Model.extend({
  
  displayChecked: function() {
    if (this.get('selected')) {return ', checked';}
  }
  
});