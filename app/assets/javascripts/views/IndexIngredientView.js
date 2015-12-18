App.Views.IndexIngredientView = Backbone.View.extend({
  
  initialize: function() {
    
    this.$el = $('#IngredientTypeGrid'),
    
    this.listenTo(this.collection, 'add', this.addOne);
    
    this.collection.fetch();

  },
  
  addOne: function(ingredient_type) {
    var view = new App.Views.IngredientTypeView({model: ingredient_type});
    this.$el.append(view.render().el);
  }
  
});