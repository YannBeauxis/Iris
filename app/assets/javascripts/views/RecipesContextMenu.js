App.Views.RecipesContextMenu= Backbone.View.extend({
  
  initialize: function(options) {
    this.options = options.options;
  },

  events: {
    "click .current-user-toggle":  "toggleCurrentUser",
  },
  
  toggleCurrentUser: function(){
    var btn = this.$el.find('.current-user-toggle');
    var subTitle = $('#MainContent').find('.subtitle');
    var status = ['Toutes les recettes','Mes recettes'];
    if (btn.hasClass('active')) {
       this.trigger('undoFilter');
       btn.text(status[1]);
       subTitle.text(status[0]);
    } else {
      this.trigger('filterCurrentUser');
      btn.text(status[0]);
       subTitle.text(status[1]);
    }
    btn.toggleClass('active');
    this.options.mainView.items.trigger('sortByName');
  },

});