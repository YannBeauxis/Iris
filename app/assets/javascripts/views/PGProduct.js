App.Views.PGProduct = Backbone.View.extend({
  
  tagName: 'tr',
  
  className: 'product',
  
  template: JST['pg_product'],

  initialize: function() {
      this.model.bind('change', this.render, this);
      if (this.model.get('production_date') == null) {
        var today = new Date('1900/01/01');
        var sort_key = today;
      } else {
        var sort_key = new Date(this.model.get('production_date'));
      }
      sort_key = App.convertDateYearFirst(sort_key);
      this.$el.attr({sort_key: sort_key});
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