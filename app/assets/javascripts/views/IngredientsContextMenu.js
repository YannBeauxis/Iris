App.Views.IngredientsContextMenu= Backbone.View.extend({
  
  initialize: function(options) {
    this.options = options.options;
  },
  
  events: {
    "click .in-stock-toggle":  "toggleStock",
  },
  
  toggleStock: function(){
    var btn = this.$el.find('.in-stock-toggle');
    var subTitle = $('#MainContent').find('.subtitle');
    var status = ['Tous les ingrédients','Ingrédients en stock'];
    if (btn.hasClass('active')) {
       this.trigger('undoFilter');
       btn.text(status[1]);
       subTitle.text(status[0]);
    } else {
      this.trigger('filterStock');
      btn.text(status[0]);
       subTitle.text(status[1]);
    }
    btn.toggleClass('active');
    this.options.mainView.items.trigger('sortByName');
  },
  
});