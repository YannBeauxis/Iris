App.Views.IngredientType = Backbone.View.extend({
  
  tagname: 'div',
  
  id: function(){
    return 'ingredient-type-' + this.model.get('id');
  },
  
  className: 'category col-xs-6 col-sm-4',
  
  template: JST['ingredient_type'],

    events: {
      "click":  "displayIngredients",
    },

  render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
  },
  
  displayIngredients: function() {
    var p = this.$el.position().top;
    this.$el.toggleClass('col-xs-6 col-sm-4');
    this.$el.toggleClass('col-xs-12');
    var pdiff = this.$el.position().top - p;
    var p = this.$el.position().top;
    //window.scrollBy(0,pdiff);
    $(window).scrollTop(p - 20);
    this.$el.find('table.ingredients').slideToggle();
  }
  
});