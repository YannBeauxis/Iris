App.Views.ContextMenu= Backbone.View.extend({
  
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
  },
  
});