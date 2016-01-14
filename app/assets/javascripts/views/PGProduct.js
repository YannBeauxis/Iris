App.Views.PGProduct = Backbone.View.extend({
  
  tagName: 'tr',
  
  className: 'product',
  
  template: JST['pg_product'],

  initialize: function() {
      this.model.bind('change', this.render, this);
  },

  events: {
    "click":  "displayProduct",
    "click .product--delete":  "deleteProduct"
  },

  displayProduct: function() {
    this.trigger('displayProduct',this.model);
  },

  deleteProduct: function(e) {
    e.stopPropagation();
    self = this;
    this.model.destroy({
      success: function() {
        self.$el.slideUp();
        self.remove();
      }
    });
  },

  render: function () {
    this.$el.html(this.template(this.model));
    return this;
  }

});