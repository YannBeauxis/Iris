App.Views.IngredientTypeView = Backbone.View.extend({
  
  tagname: 'div',
  
  className: 'ingredient-type col-xs-6 col-sm-4 panel panel-default',
  
  template: JST['ingredient_type'],

    events: {
      "click":  "displayIngredients",
    },

  render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
  },
  
  displayIngredients: function() {
    this.$el.toggleClass('col-xs-6 col-sm-4');
  }
  
});