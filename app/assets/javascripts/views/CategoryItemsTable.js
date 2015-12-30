App.Views.CategoryItemsTable = Backbone.View.extend({
  
  tagName: 'table',
  
  className: 'table items-table table-striped',

  initialize: function(options) {

    this.options = options.options;
    
    this.template = JST[this.options.templates['categoryItemsTable']];
    
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