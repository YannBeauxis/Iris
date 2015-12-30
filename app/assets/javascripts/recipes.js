var ready = function() {
 
  var options = {
    mainEl: '#CategoryGrid', 
    category: {
      collection: App.Collections.RecipeTypes,
      model: App.Models.RecipeType,
      rawData: App.recipeTypesRaw
    },
    item: {
      collection: App.Collections.Recipes,
      model: App.Models.Recipe,
      rawData: App.recipesRaw
    },
    templates: {
      category: 'category_panel_std',
      categoryItemsTable: 'recipes_table',
      item: 'recipe_row'
    },
    contextMenu: App.Views.RecipesContextMenu
  };
  
  //console.log(options);
  
  App.recipesApp = new App.Views.CategoryGrid(options);
  
};

$(document).ready(ready);
