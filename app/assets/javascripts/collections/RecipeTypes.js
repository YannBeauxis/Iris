App.Collections.RecipeTypes = Backbone.Collection.extend({
  
  model: App.Models.RecipeType,
  
  url:'/recipe_types',
  
  comparator: 'name'
  
});