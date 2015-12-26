App.Views.IngredientType = Backbone.View.extend({
  
  tagName: 'div',
  
  id: function(){
    return 'ingredient-type-' + this.model.get('id');
  },
  
  className: function(){
    this.closedClass = 'col-xs-12 col-sm-6 col-md-4 closed';
    this.openClass = 'col-xs-12 open';
    return 'category ' + this.closedClass;
    },
  
  template: JST['ingredient_type'],

  initialize: function() {
    this.collection = new App.Collections.Ingredients();
    this.listenTo(App.ingredients, 'add', this.addIngredient);

    this.ingredientsTableView = 
      new App.Views.IngredientsTable({
        model: this.model, 
        collection: this.collection
      });
    this.badgeView = 
      new App.Views.IngredientTypeBadge({model: this.model, collection: this.collection});

  },

  events: {
    "click .panel-heading":  "displayIngredients",
  },

  addIngredient: function(ingredient) {
    if (ingredient.get('ingredient_type_id') == this.model.get('id'))
      {
        this.showIngredient(ingredient);
        this.listenTo(ingredient, 'hide', this.removeIngredient);
        this.listenTo(ingredient, 'show', this.showIngredient);
      }
  },

  showIngredient: function(ingredient) {
    if (!this.collection.findWhere({id: ingredient.id})) {
      this.collection.add(ingredient);
      var view = new App.Views.Ingredient({
        model: ingredient
      });
      this.$el.find('.ingredients-table').find('tbody').append(view.render().el);
    }
  },


  removeIngredient: function(ingredient) {
    this.collection.remove(ingredient);
  },

  render: function() {
    
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.find('.default-hidden').append(this.ingredientsTableView.render().el);
      this.$el.find('.panel-heading').prepend(this.badgeView.render().el);
      
      return this;
  },
  
  displayIngredients: function() {
    this.$el.toggleClass(this.closedClass);
    this.$el.toggleClass(this.openClass);
    var p = this.$el.position().top;
    $('html, body').animate({
      scrollTop:this.$el.offset().top
      }, 'slow');
    this.$el.find('.default-hidden')
      .slideToggle();

  },
  
  scrollAnim: function(p){
    console.log(p);
    $(window).scrollTop(p - 5);
  }
  
});