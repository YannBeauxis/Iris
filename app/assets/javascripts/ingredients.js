var ready = function() {
 
  App.cgMode ='index';
 
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
      category: 'mv_category',
      item: 'mv_item'
    },
    contextMenu: App.Views.IngredientsContextMenu
  };
  
  App.ingredientsApp = new App.Views.MV_Main(options);
  
};

$(document).ready(ready);
