var ready = function() {

  switch(App.launch) {
    case 'recipeGrid':
      recipeGrid();
      break;
    case 'productGenerator':
      productGenerator();
      break;
  }

};

var recipeGrid = function() {

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

var productGenerator = function() {
    App.productGenerator = new App.Views.ProductGenerator({
      el: $('#ProductGenerator').get(0)
    });
};

$(document).ready(ready);
