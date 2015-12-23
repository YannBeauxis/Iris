App.Views.IngredientType = Backbone.View.extend({
  
  tagName: 'div',
  
  id: function(){
    return 'ingredient-type-' + this.model.get('id');
  },
  
  className: 'category col-xs-6 col-sm-4',
  
  template: JST['ingredient_type'],

  initialize: function() {
    this.badgeView = new App.Views.IngredientTypeBadge({model: this.model, collection: App.ingredients});
  },

    events: {
      "click .panel-heading":  "displayIngredients",
    },

  render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.find('.panel-heading').append(this.badgeView.$el);
      return this;
  },
  
  displayIngredients: function() {
    var p = this.$el.position().top;
    this.$el.find('.default-hidden').slideToggle();
    this.$el.toggleClass('col-xs-6 col-sm-4');
    this.$el.toggleClass('col-xs-12');
    var pdiff = this.$el.position().top - p;
    var p = this.$el.position().top;
    //window.scrollBy(0,pdiff);
    $(window).scrollTop(p - 20);

  }
  
});