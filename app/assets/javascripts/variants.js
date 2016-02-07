var ready = function() {

  variantForm();

};

var variantForm = function() {

  //cg mode to specify some actions
  App.cgMode = 'form';

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
      categoryItemsTable: 'ingredients_select_recipe_table',
      item: 'ingredient_select_recipe_row'
    },
    contextMenu: App.Views.IngredientsContextMenu,
    badgeOnSelected: true
  };  
  
  App.variantsApp = new App.Views.CategoryGrid(options);
  
  App.variantsApp.loadData;
  
};

$(document).ready(ready);
