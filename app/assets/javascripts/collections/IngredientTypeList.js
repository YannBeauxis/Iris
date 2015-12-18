App.Collections.IngredientTypeList = Backbone.Collection.extend({
  
  model: App.Models.IngredientType,
  
  url:'/ingredient_types'
  
});