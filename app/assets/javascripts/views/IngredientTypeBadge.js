App.Views.IngredientTypeBadge = Backbone.View.extend({
  
  tagName: 'span',
  
  className: 'badge',
 
  initialize: function(){
    this.listenTo(this.collection, 'add reset remove', this.render);
  },
 
  render: function(){
    this.$el.text(this.collection.where({ingredient_type_id: this.model.id}).length);
    return this;
  }
  
});