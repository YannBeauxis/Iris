App.Views.PGProduct = Backbone.View.extend({
  
  tagName: 'tr',
  
  className: 'product',
  
  template: JST['pg_product'],

  events: {
    "click":  "displayProduct"
  },

  render: function () {
    this.$el.html(this.template(this.model));
    return this;
  },

  displayProduct: function() {
    this.trigger('displayProduct',this.model);
  }


});