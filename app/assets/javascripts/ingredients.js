var ready = function() {
 
  var options = {
    mainEl: '#CategoryGrid', 
    category: {
      collection: App.Collections.IngredientTypes,
      model: App.Models.IngredientType
    },
    item: {
      collection: App.Collections.Ingredients,
      model: App.Models.Ingredient
    },
    templates: {
      category: 'category_panel_std',
      categoryItemsTable: 'ingredients_table',
      item: 'ingredient_row'
    },
    contextMenu: App.Views.IngredientsContextMenu
  };
  
  App.ingredientsApp = new App.Views.CategoryGrid(options);
  
};

$(document).ready(ready);
