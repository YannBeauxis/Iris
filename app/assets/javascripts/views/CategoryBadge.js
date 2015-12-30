App.Views.CategoryBadge = Backbone.View.extend({
  
  tagName: 'div',
  
  className: 'badge',
 
  initialize: function() {
    this.listenTo(this.collection, 'add reset remove', this.render);
  },
 
  render: function(){
    this.$el.text(this.collection.length);
    return this;
  }
});