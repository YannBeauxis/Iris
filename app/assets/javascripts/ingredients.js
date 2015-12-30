var ready = function() {
 
  var options = {
    mainEl: '#CategoryGrid', 
    category: {
      collection: App.Collections.IngredientTypes,
      model: App.Models.IngredientType,
      rawData: App.ingredientTypesRaw
    },
    item: {
      collection: App.Collections.Ingredients,
      model: App.Models.Ingredient,
      rawData: App.ingredientsRaw
    },
    templates: {
      category: 'category_panel_std',
      categoryItemsTable: 'ingredients_table',
      item: 'ingredient_row'
    },
    contextMenu: App.Views.IngredientsContextMenu
  };
  
  //console.log(options);
  
  App.ingredientsApp = new App.Views.CategoryGrid(options);
  
};

$(document).ready(ready);
