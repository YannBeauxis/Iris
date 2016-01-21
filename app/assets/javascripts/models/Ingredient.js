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
  }

});