App.Views.Ingredients = Backbone.View.extend({
  
  initialize: function() {
    
    App.sortByName = function(elTarget) {
      elTarget.append(
          elTarget.children().sort(function (a,b) {
          aName = $(a).attr('name');
          bName = $(b).attr('name');
          return (aName < bName) ? -1 : (bName < aName) ? 1 : 0;
        })
      );
      return elTarget;
    };
    
    this.$el = $('#CategoryGrid'),
    this.$el.hide();
    
    App.contextMenuView = new App.Views.ContextMenu({el: $('#ContextMenu')});
    
    App.ingredients = new App.Collections.Ingredients();
    App.ingredientTypes = new App.Collections.IngredientTypes();
    
    this.listenTo(App.ingredientTypes, 'add', this.addOneType);
    this.listenTo(App.ingredients, 'add', this.addOneIngredient);    

    App.ingredientTypes.add(App.ingredientTypesRaw);
    App.ingredients.add(App.ingredientsRaw);    

    App.ingredients.trigger('sortByName');
    App.sortByName(this.$el).show();
    
  },
  
  addOneType: function(ingredient_type) {
    var view = new App.Views.IngredientType({
                      model: ingredient_type
                    });
    var it = this.$el.append(view.render().el);
    it.find('.default-hidden').hide();
  },
  
  sortByName: function() {
    this.$el.append(
        this.$el.children().sort(function (a,b) {
        aName = $(a).attr('name');
        bName = $(b).attr('name');
        return (aName < bName) ? -1 : (bName < aName) ? 1 : 0;
      })
    );
    return this.$el;
  }
  
});