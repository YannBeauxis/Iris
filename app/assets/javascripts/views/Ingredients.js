App.Views.Ingredients = Backbone.View.extend({
  
  initialize: function() {
    
    this.$el = $('#IngredientTypeGrid'),
    
    App.ingredients = new App.Collections.Ingredients();
    App.ingredient_types = new App.Collections.IngredientTypes();
    
    this.listenTo(App.ingredient_types, 'add', this.addOneType);
    this.listenTo(App.ingredients, 'add', this.addOneIngredient);    
    this.fetch_item_and_types();

  },
  
  fetch_item_and_types: function(){
    App.ingredient_types.fetch({
      success: function(){
        App.ingredients.fetch();
      }
    });
  },
  
  addOneType: function(ingredient_type) {
    var view = new App.Views.IngredientType({model: ingredient_type});
    var it = this.$el.append(view.render().el);
    it.find('ul.ingredients').hide();
  },

  addOneIngredient: function(ingredient) {
    var view = new App.Views.Ingredient({model: ingredient});
    view.parent_el.find('ul.ingredients').append(view.render().el);
  }
  
});