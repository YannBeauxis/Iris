App.Models.IngredientType = Backbone.Model.extend({
  
  url:'/ingredient_types',
  
  initialize: function() {
    this.ingredients = App.ingredients.where({ingredient_type_id: this.id});
  }
  
});
