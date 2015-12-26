App.Views.Ingredient= Backbone.View.extend({
  
  tagName: 'tr',
  
  id: function(){
    return 'ingredient-' + this.model.get('id');
  },
  
  className: 'selected',
  
  template: JST['ingredient_row'],

  initialize: function() {
    this.listenTo(this.model, 'hide', this.remove);  
  },

  href: function (){
    return this.model.url + '/' + this.model.get('id');
  },

  render: function() {
    this.$el.html(this.template(this));
    return this;
  },
  
});