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
    this.badgeView = new App.Views.IngredientTypeBadge({model: this.model, collection: App.ingredients});
  },

    events: {
      "click .panel-heading":  "displayIngredients",
    },

  render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.find('.panel-heading').prepend(this.badgeView.$el);
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