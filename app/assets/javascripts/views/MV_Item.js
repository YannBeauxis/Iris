App.Views.MV_Item= Backbone.View.extend({

  className: ['main-view__item'],


  initialize: function(options) {
      
    this.options = options.options;
      
    this.template = JST[this.options.templates['item']];
      
  },

  events: {
    //"click a":  "noDisplayDetails",
    //"click":  "clickItem"
  },

  href: function (){
    return this.model.url + '/' + this.model.get('id') + '.html';
  },

  render: function() {
    this.$el.html(this.template(this));
    return this;
  },
  
  clickItem: function(e) {
    // to open sub line for action
    //this.$el.find('.detail').slideToggle();
    if (App.cgMode =='index') {
      window.location = this.href();
    } else if (App.cgMode =='form') {
      var checkBoxe = this.$el.find('input.select_ingredient');
      if (e.target.tagName != 'INPUT') {
        checkBoxe.prop("checked", !checkBoxe.prop("checked"));}
      this.trigger('changeSelect');
    }
  }
  
});