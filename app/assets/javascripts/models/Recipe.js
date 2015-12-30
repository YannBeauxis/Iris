App.Models.Recipe = Backbone.Model.extend({
  
  url:'/recipes',

  initialize: function() {
    
    this.category_id = this.get('recipe_type_id');
    
    this.listenTo(App.contextMenuView, 'filterCurrentUser', this.filterCurrentUser);
    this.listenTo(App.contextMenuView, 'undoFilter', this.undoFilter);  
  },

  filterCurrentUser: function() {
    if (!this.get('is_current_user')) {
      this.trigger('hide', this);
    }
  },

  undoFilter: function() {
    this.trigger('show', this);
  }

});