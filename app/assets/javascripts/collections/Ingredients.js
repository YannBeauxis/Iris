App.Collections.Ingredients = Backbone.Collection.extend({
  
  model: App.Models.Ingredient,
  
  url:'/ingredients'
  
});