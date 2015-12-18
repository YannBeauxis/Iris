App.Views.Ingredient= Backbone.View.extend({
  
  tagName: 'li',
  //className: 'hide',
  
  //template: JST['ingredient_type'],

  initialize: function() {
    
    this.parent_id =  this.model.get('ingredient_type_id');
    this.parent_el = $('#ingredient-type-' + this.parent_id);
  },

  render: function() {
      this.$el.text(this.model.get('name'));//this.template(this.model.toJSON()));
      return this;
  },
  
});