App.Views.IngredientsTable = Backbone.View.extend({
  
  tagName: 'table',
  
  className: 'table ingredients-table table-striped',
 
  template: JST['ingredients_table'],

  initialize: function() {
    this.listenTo(this.collection, 'add reset remove', this.isShow);
  },

  isShow: function() {
    if (this.collection.length > 0){
      this.$el.show();
    } else {
      this.$el.hide();
    }
  },

  render: function(){
    this.$el.html(this.template(this));
    return this;
  }
});