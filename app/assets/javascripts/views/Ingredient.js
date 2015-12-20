App.Views.Ingredient= Backbone.View.extend({
  
  tagName: 'tr',
  //className: 'hide',
  
  template: JST['ingredient_row'],

  initialize: function() {
    
    this.parent_id =  this.model.get('ingredient_type_id');
    this.parent_el = $('#ingredient-type-' + this.parent_id);
  },

  render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
  },
  
});