var ready = function() {

  switch(App.launch) {
    case 'recipeIndex':
      recipeIndex();
      break;
    case 'recipeForm':
      recipeForm();
      break;
    case 'productGenerator':
      productGenerator();
      break;
  }

};

var recipeIndex = function() {

  //cg mode to specify some actions
  App.cgMode = 'index';
  
  var options = {
    mainEl: '#CategoryGrid', 
    category: {
      collection: App.Collections.RecipeTypes,
      model: App.Models.RecipeType,
    },
    item: {
      collection: App.Collections.Recipes,
      model: App.Models.Recipe,
    },
    templates: {
      category: 'category_panel_std',
      categoryItemsTable: 'recipes_table',
      item: 'recipe_row'
    },
    contextMenu: App.Views.RecipesContextMenu
  };
  
  App.recipesApp = new App.Views.CategoryGrid(options);
  
};

var recipeForm = function() {

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
    contextMenu: App.Views.IngredientsContextMenu
  };  
  App.recipesApp = new App.Views.CategoryGrid(options);
  
  $('#recipe_recipe_type_id').change(App.recipesApp.loadData);
  
};

var productGenerator = function() {
    App.productGenerator = new App.Views.ProductGenerator({
      el: $('#ProductGenerator').get(0)
    });
};

$(document).ready(ready);
