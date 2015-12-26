App.Collections.IngredientTypes = Backbone.Collection.extend({
  
  model: App.Models.IngredientType,
  
  url:'/ingredient_types',
  
  comparator: 'name'
  
});