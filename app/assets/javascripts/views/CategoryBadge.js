App.Views.CategoryBadge = Backbone.View.extend({
  
  tagName: 'div',
  
  className: 'badge',
 
  initialize: function(options) {
    this.options = options.options;
    this.listenTo(this.collection, 'add reset remove', this.render);
  },
 
  render: function(){
    if (this.options.badgeOnSelected) {
      this.$el.text(this.numberSelected);  
    } else {
      this.$el.text(this.collection.length);      
    }

    return this;
  }
});