App.Views.IngredientTypeBadge = Backbone.View.extend({
  
  tagName: 'div',
  
  className: 'badge',
 
  initialize: function() {
    this.listenTo(this.collection, 'add reset remove', this.render);
  },
 
  render: function(){
    this.parent_id =  this.model.get('id');
    this.parent_el = $('#ingredient-type-' + this.parent_id);
    this.$el.text(this.parent_el.find('table.ingredients').find('tbody').find('tr.selected').length);
    return this;
  }
});