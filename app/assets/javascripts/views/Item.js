App.Views.Item= Backbone.View.extend({
  
  tagName: 'tr',

  attributes: function(){
      return {name: this.model.get('name')};
    },

  initialize: function(options) {
    
    this.options = options.options;
    
    this.template = JST[this.options.templates['item']];
    
    this.listenTo(this.model, 'hide', this.remove);  
  },

  events: {
    "click a":  "noDisplayDetails",
    "click":  "displayDetails"
  },

  href: function (){
    return this.model.url + '/' + this.model.get('id');
  },

  render: function() {
    this.$el.html(this.template(this));
    return this;
  },
  
  noDisplayDetails: function (e) {
    e.stopPropagation();
    return true;
  },  
  
  displayDetails: function() {
    // to open sub line for action
    //this.$el.find('.detail').slideToggle();
    window.location = this.href();
  }
  
});