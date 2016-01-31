App.Models.Ingredient = Backbone.Model.extend({
  
  url:'/ingredients',

  initialize: function() {

    this.category_id = this.get('ingredient_type_id');
    
    this.listenTo(App.contextMenuView, 'filterStock', this.filterStock);
    this.listenTo(App.contextMenuView, 'undoFilter', this.undoFilter);  
  },

  filterStock: function() {
    if (!this.get('stock')) {
      this.trigger('hide', this);
    }
  },

  undoFilter: function() {
    this.trigger('show', this);
  },

  displayChecked: function() {
    if (this.get('selected')) {return 'checked';}
  },

  displayQuantity: function() {
    unit = this.get('mesure_unit');
    stock = this.get('stock');
    if (stock != null) {
      if (stock<100000) {
        return stock/100 + ' ' + unit;
      } else {
        if (unit == 'ml') {
          unit = 'L';
        } else {
          unit = 'k' + unit;
        }
        return Math.round(stock/1000)/100 + ' ' + unit;
      }
    }
  }

});