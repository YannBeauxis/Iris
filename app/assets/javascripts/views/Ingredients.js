App.Views.Ingredients = Backbone.View.extend({
  
  initialize: function() {
    
    this.$el = $('#CategoryGrid'),
    
    this.$el.hide();
    
    App.ingredients = new App.Collections.Ingredients();
    App.ingredientTypes = new App.Collections.IngredientTypes();
    
    this.listenTo(App.ingredientTypes, 'add', this.addOneType);
    this.listenTo(App.ingredients, 'add', this.addOneIngredient);    

    App.ingredientTypes.add(App.ingredientTypesRaw);
    App.ingredients.add(App.ingredientsRaw);
    
    this.$el.show();
    
  },
  
  addOneType: function(ingredient_type) {
    var view = new App.Views.IngredientType({model: ingredient_type});
    var it = this.$el.append(view.render().el);
    it.find('.default-hidden').hide();
  },

  addOneIngredient: function(ingredient) {
    var view = new App.Views.Ingredient({model: ingredient});
    view.parent_el.find('table.ingredients').find('tbody').append(view.render().el);
  }
  
});