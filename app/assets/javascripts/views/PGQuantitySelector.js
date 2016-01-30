App.Views.PGQuantitySelector = Backbone.View.extend({
  
  className: 'checkbox quantity-selector',

  initialize: function(options) {

    this.template = JST['pg_quantity_selector'];

  },
  
  events: {
    "change":  "clickItem"
  },

  clickItem: function(){
    options = {
      quantityType: this.$el.attr('selector'), 
      display: this.$el.find('input').is(':checked')};
    this.trigger('selectorClick', options);
  },

  render: function() {
    this.$el.html(this.template(this.model));
    return this;
  },

});