App.Collections.Recipes = Backbone.Collection.extend({
  
  model: App.Models.Recipe,
  
  url:'/recipes'
  
});