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
    this.$el.toggleClass('col-xs-6 col-sm-4 col-xs-12');
    //this.$el.toggleClass('col-xs-12');
    var p = this.$el.position().top;
    $('html, body').animate({
      scrollTop:this.$el.offset().top
      }, 'slow');
    //$(window).scrollTop(p - 10);
    this.$el.find('.default-hidden')
      .slideToggle();
      //.slideToggle('normal', function(){$(window).scrollTop(p-10);});


    //$(window).scrollTop(p - 5);
  },
  
  scrollAnim: function(p){
    console.log(p);
    $(window).scrollTop(p - 5);
  }
  
});